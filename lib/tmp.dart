import 'package:custom_radio/custom_radio.dart';
import 'package:flutter/material.dart';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Custom Radio demo',
            home: MyHomePage(title: 'Custom Radio example')
        );
    }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  int radioValue = 0;

  final AnimationsBuilder _animsBuilder = (AnimationController controller) {
    return [
      CurvedAnimation(
        parent: controller,
        curve: Curves.ease,
      ),
      CurvedAnimation(
        parent: controller,
        curve: Curves.ease,
      )
    ];
  };
  final dynamic customBuilder = (int value, Color color) {
    return ({ BuildContext context, List<dynamic> animValues, Function updateState, bool checked }) {
      return Container(
        width: double.infinity,
        height: animValues[0] * 50 + 50,
        color: color.withAlpha((animValues[1] * 255).floor()),
        child: Center(
          child: Text(
            value.toString()
          )
        ),
      );
    };
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: <Widget>[
          CustomRadio<int, dynamic>(
            value: 0,
            groupValue: radioValue,
            duration: Duration(milliseconds: 800),
            animsBuilder: _animsBuilder,
            builder: customBuilder(0, Colors.blueAccent)
          ),
          CustomRadio<int, dynamic>(
            value: 1,
            groupValue: radioValue,
            duration: Duration(milliseconds: 800),
            animsBuilder: _animsBuilder,
            builder: customBuilder(1, Colors.redAccent),
          ),
          CustomRadio<int, dynamic>(
            value: 2,
            groupValue: radioValue,
            duration: Duration(milliseconds: 800),
            animsBuilder: _animsBuilder,
            builder: customBuilder(2, Colors.greenAccent),
          ),
        ],
      ),
    );
  }

}