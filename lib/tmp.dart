// This is a modified version of the ExpansionTile built by the Flutter team,
// which can be found here: https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/expansion_tile.dart
// I just changed it to behave a little more like an ExpansionPanel,
// but still have the UI customization capabilities of an ExpansionTile.
// While also behaving like a radio button.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';  // apparently I need this on linux, though it works fine on mac without.

const Duration _kExpand = const Duration(milliseconds: 200);

typedef Future ExpansionChanged<T>(T value);


class RadioExpansion<T> extends StatefulWidget {

  const RadioExpansion({
    Key key,
    this.leading,
    this.title,
    this.backgroundColor,
    this.children = const <Widget>[],
    this.trailing,
    @required this.onChanged,
    @required this.value,
    @required this.groupValue,
  }) : super(key: key);

  /// A widget to display before the title.
  ///
  /// Typically a [CircleAvatar] widget.
  final Widget leading;

  /// The primary content of the list item.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// The widgets that are displayed when the tile expands.
  ///
  /// Typically [ListTile] widgets.
  final List<Widget> children;

  /// The color to display behind the sublist when expanded.
  final Color backgroundColor;

  /// A widget to display instead of a rotating arrow icon.
  final Widget trailing;

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for this group of radio buttons.
  ///
  /// This radio button is considered selected if its [value] matches the
  /// [groupValue].
  final T groupValue;

  bool get checked => value == groupValue;

  /// Called when the tile is tapped. If a value other than null is returned,
  /// the widget will set it to be its group value and rebuild.
  final ExpansionChanged<T> onChanged;

  @override
  _RadioExpansionState createState() => _RadioExpansionState<T>();

}


class _RadioExpansionState<T> extends State<RadioExpansion> with SingleTickerProviderStateMixin {

  _RadioExpansionState();

  AnimationController _controller;
  CurvedAnimation _easeOutAnimation;
  CurvedAnimation _easeInAnimation;
  ColorTween _borderColor;
  ColorTween _headerColor;
  ColorTween _iconColor;
  ColorTween _backgroundColor;
  Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _easeOutAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _easeInAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _borderColor = ColorTween();
    _headerColor = ColorTween();
    _iconColor = ColorTween();
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(_easeInAnimation);
    _backgroundColor = ColorTween();

    if (widget.checked)
      _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onChanged(widget.value)
      .then((_) => updateState());
  }

  void updateState() {
    setState(() {
      if (widget.checked)
        _controller.forward();
      else
        _controller.reverse().then<void>((Null value) {
          setState(() {
            // Rebuild without widget.children.
          });
        });
    });
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final Color borderSideColor = _borderColor.evaluate(_easeOutAnimation) ?? Colors.transparent;
    final Color titleColor = _headerColor.evaluate(_easeInAnimation);

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor.evaluate(_easeOutAnimation) ?? Colors.transparent,
        border: Border(
          top: BorderSide(color: borderSideColor),
          bottom: BorderSide(color: borderSideColor),
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme.merge(
            data: IconThemeData(color: _iconColor.evaluate(_easeInAnimation)),
            child: ListTile(
              onTap: _handleTap,
              leading: widget.leading,
              title: DefaultTextStyle(
                style: Theme.of(context).textTheme.subhead.copyWith(color: titleColor),
                child: widget.title,
              ),
              trailing: widget.trailing ?? RotationTransition(
                turns: _iconTurns,
                child: const Icon(Icons.expand_more),
              ),
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _easeInAnimation.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (
      (widget.checked &&
      (_controller.status == AnimationStatus.dismissed || _controller.status == AnimationStatus.reverse)) ||
      (!widget.checked &&
      (_controller.status == AnimationStatus.completed || _controller.status == AnimationStatus.forward))
    ) {
      updateState();
    }

    final ThemeData theme = Theme.of(context);
    _borderColor.end = theme.dividerColor;
    _headerColor
      ..begin = theme.textTheme.subhead.color
      ..end = theme.accentColor;
    _iconColor
      ..begin = theme.unselectedWidgetColor
      ..end = theme.accentColor;
    _backgroundColor.end = widget.backgroundColor;

    final bool closed = !widget.checked && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );

  }
}v