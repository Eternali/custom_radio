library custom_radio;

import 'package:flutter/material.dart';

typedef List<Animation> AnimationsBuilder(AnimationController controller);

typedef Widget RadioBuilder<T>({
  BuildContext context,
  List<double> animValues,
  Function updateState,
  T value,
});

class CustomRadio<T> extends StatefulWidget {

  final RadioBuilder<T> builder;
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
  }) : assert(duration != null), super(key: key);

  @override
  State<CustomRadio> createState() => _CustomRadioState();

}

class _CustomRadioState extends State<CustomRadio> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  List<Animation> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animations = widget.animsBuilder(_controller);
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
        _controller.reverse()
          .then((Null value) {
            setState(() {  });
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (
      (widget.checked &&
      (_controller.status == AnimationStatus.dismissed || _controller.status == AnimationStatus.reverse)) ||
      (!widget.checked &&
      (_controller.status == AnimationStatus.completed || _controller.status == AnimationStatus.forward))
    ) {
      _updateState();
    }

    return widget.builder(
      context: context,
      animValues: _animations.map<double>((anim) => anim.value),
      updateState: _updateState,
      value: widget.value,
    );
  }

}
