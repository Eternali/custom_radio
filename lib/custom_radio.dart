/// Copyright (c) 2018 Conrad Heidebrecht. All rights reserved.
/// Licensed under the MIT license. See LICENSE file in the project root for details.

library custom_radio;

import 'package:flutter/material.dart';

typedef AnimationsBuilder<T> = List<Animation<T>> Function(AnimationController);

typedef RadioBuilder<T, U> = Widget Function(@deprecated BuildContext context, List<U> animValues, Function updateState, T value);

/// A custom radio widget.
///
/// Used to select between a number of mutually exclusive values. When one radio
/// widget in a group is selected, the other radios in the group cease to
/// be selected. The values are of type `T`, the first type parameter of the [CustomRadio]
/// class. Enums are commonly used for this purpose.
/// 
/// Animation values are of type `U`, the second type parameter of the [CustomRadio] class,
/// this allows for stronger typing if only one type of animation is required. This can
/// be set to `dynamic` if more than one type of animation is required.
class CustomRadio<T, U> extends StatefulWidget {
/// Builds the radio button with animation state.
/// 
/// [BuildContext] context into which to build,
/// [List<U>] animValues (current values of running animations),
/// [Function] updateState (call to manually update the state of the widget),
/// [T] copy of radio value of the widget

  final RadioBuilder<T, U> builder;

  /// The duration of the animation controller
  final Duration duration;

  /// Returns the list of child animations whose values will be passed to the builder.
  /// Called on initState.
  final AnimationsBuilder<U> animsBuilder;
  
  /// The value represented by this radio button.
  final T value;
  
  /// The currently selected value for this group of radio buttons.
  /// 
  /// This radio button is considered selected if its [value] matches the
  /// [groupValue].
  final T groupValue;

  bool get checked => value == groupValue;

  /// Creates a custom radio widget.
  /// 
  /// The widget itself does not maintain any state. Instead, it is up to
  /// the user to rebuild the radio widget when [groupValue] changes.
  /// The widget will automatically update its animation controller when
  /// it detects a change.
  /// 
  /// If no [animsBuilder] is passed, the widget will switch between selected
  /// states with no animation and the [animValues] passed to [builder] will be a
  /// list with the only element being whether the widget is checked or not.
  /// 
  /// The following arguments are required:
  /// 
  /// * [value] and [groupValue] together determine whether the radio button
  ///   is selected.
  /// * [builder] creates the visual layout of the widget.
  CustomRadio({
    Key key,
    this.animsBuilder,
    this.duration = const Duration(milliseconds: 600),
    @required this.builder,
    @required this.value,
    @required this.groupValue,
  })  : assert(duration != null),
        super(key: key);

  @override
  State<CustomRadio> createState() => _CustomRadioState<T, U>();
}

class _CustomRadioState<T, U> extends State<CustomRadio<T, U>>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<Animation> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animations = widget.animsBuilder(_controller);
    _animations.forEach((anim) => anim.addListener(() => setState(() {})));
    if (widget.checked)
      _controller.value = 1.0;
    else
      _controller.value = 0.0;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _updateState() {
    setState(() {
      if (widget.checked && _controller.status != AnimationStatus.completed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if ((widget.checked &&
            (_controller.status == AnimationStatus.dismissed ||
                _controller.status == AnimationStatus.reverse)) ||
        (!widget.checked &&
            (_controller.status == AnimationStatus.completed ||
                _controller.status == AnimationStatus.forward))) {
      _updateState();
    }

    final anims = _animations.map<U>((anim) => anim.value).toList();
    return widget.builder(
      context,
      anims.length > 0 ? anims : [widget.checked].cast<dynamic>(),
      _updateState,
      widget.value,
    );
  }
}
