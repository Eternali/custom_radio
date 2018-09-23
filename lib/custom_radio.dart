library custom_radio;

import 'package:flutter/material.dart';

typedef List<Animation> AnimationsBuilder(AnimationController controller);

typedef Widget RadioBuilder<U>({
  BuildContext context,
  List<U> animValues,
  Function updateState,
  bool checked,
});

class CustomRadio<T, U> extends StatefulWidget {
  final RadioBuilder builder;
  final Duration duration;
  final AnimationsBuilder animsBuilder;
  final T value;
  final T groupValue;

  bool get checked => value == groupValue;

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
  State<CustomRadio> createState() => _CustomRadioState<U>();
}

class _CustomRadioState<U> extends State<CustomRadio>
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
        _controller.reverse().then((Null value) {
          setState(() {});
        });
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
      context: context,
      animValues: anims.length > 0 ? anims : [widget.checked ? 1.0 : 0.0],
      updateState: _updateState,
      checked: widget.checked,
    );
  }
}
