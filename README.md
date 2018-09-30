# custom_radio

An animatable radio button that can be customized to the max.

I found it strange that flutter only provides two radio widgets: __Radio__ and __RadioListTile__
The main issue with these widgets is that both of them force the use of the default Android leading animated circular icon.
This widget leaves everything up to the user by allowing them to provide their own builder function.
On top of that, an animations builder can also be provided. This gets passed a parent animation controller with which the user can then use to create a list of animations that can animate the widgets transition between states.

# Installation
Simply add `custom_radio: ^0.1.2` as a dependancy in your pubspec.yaml file.
Then `import 'package:custom_radio/custom_radio.dart';` wherever you need it.

# Examples
![](example/example.gif)

If only one animation type is required then it can be specified to enable stronger typing.
```
CustomRadio<double, >
```
![](single_example.gif)

But any combination of animation types are supported.
```
CustomRadio<int, dynamic>(
  value: 0,
  groupValue: widget.radioValue,
  duration: Duration(milliseconds: 800),
  animsBuilder: (AnimationController controller) => [
    CurvedAnimation(
      parent: controller,
      curve: Curves.ease,
    ),
    ColorTween(begin: Colors.greenAccent.withAlpha(200), end: Colors.green).animate(controller),
  ],
  builder: ({ BuildContext context, List<dynamic> animValues, Function updateState, bool checked }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.radioValue = 0;
        });
      },
      child: Container(
        width: double.infinity,
        height: animValues[0] * 50 + 80,
        color: animValues[1],
        child: Center(
          child: Text(
            value.toString()
          )
        ),
      ),
    );
  }
)
```
![](multi_example.gif)

You can even recreate the default animation provided by _Radio_ and add your own personal flairs!
Note: The full example can be found in the `example` directory
```
CustomRadio<int, double>(
  value: value,
  groupValue: widget.radioValue,
  duration: Duration(milliseconds: 400),
  animsBuilder: (AnimationController controller) => [
    CurvedAnimation(
      parent: controller,
      curve: Curves.ease
    )
  ],
  builder: ({ BuildContext context, List<double> animValues, Function updateState, bool checked }) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          if (_controller.status != AnimationStatus.completed)
            _controller.forward();
        });
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          if (_controller.status != AnimationStatus.dismissed)
            _controller.reverse();
        });
      },
      onTap: () {
        setState(() {
          widget.radioValue = value;
        });
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        width: 38.0,
        height: 38.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 38.0 * _animation.value,
              height: 38.0 * _animation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withAlpha(40)
              ),
            ),
            Container(
              width: 18.0,
              height: 18.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: checked ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                  width: 2.0
                )
              ),
            ),
            Container(
              width: 11.0 * animValues[0],
              height: 11.0 * animValues[0],
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ]
        ),
      )
    );
  }
)
```
![](radio_clone.gif)
