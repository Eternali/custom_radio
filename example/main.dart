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
        home: MyHomePage(title: 'Custom Radio example'));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  int radioValue = 0;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() {
    customBuilder = () {
      return (
          {BuildContext context,
          List<dynamic> animValues,
          Function updateState,
          int value}) {
        return GestureDetector(
          onTap: () {
            setState(() {
              widget.radioValue = value;
            });
          },
          child: Container(
            width: double.infinity,
            height: animValues[0] * 50 + 80,
            color: animValues[1],
            child: Center(child: Text(value.toString())),
          ),
        );
      };
    };
  }

  dynamic customBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: <Widget>[
          CustomRadio<int, dynamic>(
              value: 0,
              groupValue: widget.radioValue,
              duration: Duration(milliseconds: 800),
              animsBuilder: (AnimationController controller) => [
                    CurvedAnimation(
                      parent: controller,
                      curve: Curves.ease,
                    ),
                    ColorTween(
                            begin: Colors.greenAccent.withAlpha(200),
                            end: Colors.green)
                        .animate(controller),
                  ],
              builder: customBuilder()),
          CustomRadio<int, dynamic>(
            value: 1,
            groupValue: widget.radioValue,
            duration: Duration(milliseconds: 800),
            animsBuilder: (AnimationController controller) => [
                  CurvedAnimation(
                    parent: controller,
                    curve: Curves.ease,
                  ),
                  ColorTween(
                          begin: Colors.redAccent.withAlpha(200),
                          end: Colors.red)
                      .animate(controller),
                ],
            builder: customBuilder(),
          ),
          CustomRadio<int, dynamic>(
            value: 2,
            groupValue: widget.radioValue,
            duration: Duration(milliseconds: 800),
            animsBuilder: (AnimationController controller) => [
                  CurvedAnimation(
                    parent: controller,
                    curve: Curves.ease,
                  ),
                  ColorTween(
                          begin: Colors.blueAccent.withAlpha(200),
                          end: Colors.blue)
                      .animate(controller),
                ],
            builder: customBuilder(),
          ),
        ],
      ),
    );
  }
}
