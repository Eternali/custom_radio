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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  String radioValue = 'First';

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  _MyHomePageState() {
    customBuilder = (BuildContext context, List<dynamic> animValues, Function updateState, String value) {
      return GestureDetector(
        onTap: () {
          setState(() {
            widget.radioValue = value;
          });
        },
        child: Container(
          width: double.infinity,
          height: animValues[0] * 40 + 60,
          color: animValues[1],
          child: Center(
            child: Text(
              value
            )
          ),
        ),
      );
    };
    simpleBuilder = (BuildContext context, List<double> animValues, Function updateState, String value) {
      final alpha = (animValues[0] * 255).toInt();
      return GestureDetector(
        onTap:  () {
          setState(() {
            widget.radioValue = value;
          });
        },
        child: Container(
          padding: EdgeInsets.all(32.0),
          margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 12.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor.withAlpha(alpha),
            border: Border.all(
              color: Theme.of(context).primaryColor.withAlpha(255 - alpha),
              width: 4.0,
            )
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.body1.copyWith(fontSize: 20.0),
          )
        )
      );
    };
    dynamicBuilder = (BuildContext context, List<dynamic> animValues, Function updateState, String value) {
      return GestureDetector(
        onTap: () {
          setState(() {
            widget.radioValue = value;
          });
        },
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
          padding: EdgeInsets.all(32.0 + animValues[0] * 12.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: animValues[1],
            border: Border.all(
              color: animValues[2],
              width: 2.0
            )
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.body1.copyWith(
              fontSize: 20.0,
              color: animValues[2]
            ),
          )
        )
      );
    };
  }

  RadioBuilder<String, dynamic> customBuilder;
  RadioBuilder<String, double> simpleBuilder;
  RadioBuilder<String, dynamic> dynamicBuilder;

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        children: <Widget>[
          CustomRadio<String, dynamic>(
            value: 'Green',
            groupValue: widget.radioValue,
            duration: Duration(milliseconds: 800),
            animsBuilder: (AnimationController controller) => [
              CurvedAnimation(
                parent: controller,
                curve: Curves.ease,
              ),
              ColorTween(begin: Colors.greenAccent.withAlpha(200), end: Colors.green).animate(controller),
            ],
            builder: customBuilder
          ),
          CustomRadio<String, dynamic>(
            value: 'Red',
            groupValue: widget.radioValue,
            duration: Duration(milliseconds: 800),
            animsBuilder: (AnimationController controller) => [
              CurvedAnimation(
                parent: controller,
                curve: Curves.ease,
              ),
              ColorTween(begin: Colors.redAccent.withAlpha(200), end: Colors.red).animate(controller),
            ],
            builder: customBuilder,
          ),
          CustomRadio<String, dynamic>(
            value: 'Blue',
            groupValue: widget.radioValue,
            duration: Duration(milliseconds: 800),
            animsBuilder: (AnimationController controller) => [
              CurvedAnimation(
                parent: controller,
                curve: Curves.ease,
              ),
              ColorTween(begin: Colors.blueAccent.withAlpha(200), end: Colors.blue).animate(controller),
            ],
            builder: customBuilder,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomRadio<String, double>(
                value: 'First',
                groupValue: widget.radioValue,
                duration: Duration(milliseconds: 500),
                animsBuilder: (AnimationController controller) => [
                  CurvedAnimation(
                    parent: controller,
                    curve: Curves.easeInOut
                  )
                ],
                builder: simpleBuilder
              ),
              CustomRadio<String, double>(
                value: 'Second',
                groupValue: widget.radioValue,
                duration: Duration(milliseconds: 500),
                animsBuilder: (AnimationController controller) => [
                  CurvedAnimation(
                    parent: controller,
                    curve: Curves.easeInOut
                  )
                ],
                builder: simpleBuilder
              ),
              CustomRadio<String, double>(
                value: 'Third',
                groupValue: widget.radioValue,
                duration: Duration(milliseconds: 500),
                animsBuilder: (AnimationController controller) => [
                  CurvedAnimation(
                    parent: controller,
                    curve: Curves.easeInOut
                  )
                ],
                builder: simpleBuilder
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomRadio<String, dynamic>(
                value: 'Fourth',
                groupValue: widget.radioValue,
                animsBuilder: (AnimationController controller) => [
                  CurvedAnimation(
                    parent: controller,
                    curve: Curves.easeInOut
                  ),
                  ColorTween(
                    begin: Colors.white,
                    end: Colors.deepPurple
                  ).animate(controller),
                  ColorTween(
                    begin: Colors.deepPurple,
                    end: Colors.white
                  ).animate(controller),
                ],
                builder: dynamicBuilder,
              ),
              CustomRadio<String, dynamic>(
                value: 'Fifth',
                groupValue: widget.radioValue,
                animsBuilder: (AnimationController controller) => [
                  CurvedAnimation(
                    parent: controller,
                    curve: Curves.easeInOut
                  ),
                  ColorTween(
                    begin: Colors.white,
                    end: Colors.deepPurple
                  ).animate(controller),
                  ColorTween(
                    begin: Colors.deepPurple,
                    end: Colors.white
                  ).animate(controller),
                ],
                builder: dynamicBuilder,
              ),
              CustomRadio<String, dynamic>(
                value: 'Sixth',
                groupValue: widget.radioValue,
                animsBuilder: (AnimationController controller) => [
                  CurvedAnimation(
                    parent: controller,
                    curve: Curves.easeInOut
                  ),
                  ColorTween(
                    begin: Colors.white,
                    end: Colors.deepPurple
                  ).animate(controller),
                  ColorTween(
                    begin: Colors.deepPurple,
                    end: Colors.white
                  ).animate(controller),
                ],
                builder: dynamicBuilder,
              ),
            ]
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio<String>(
                value: 'Seventh',
                groupValue: widget.radioValue,
                onChanged: (String value) {
                  setState(() {
                    widget.radioValue = value;
                  });
                }
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('Radio')
              )
            ],
          ),
          CustomRadio<String, double>(
            value: 'Eighth',
            groupValue: widget.radioValue,
            duration: Duration(milliseconds: 400),
            animsBuilder: (AnimationController controller) => [
              CurvedAnimation(
                parent: controller,
                curve: Curves.ease
              )
            ],
            builder: (BuildContext context, List<double> animValues, Function updateState, String value) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
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
                                color: animValues[0] >= 0.5 ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                                width: 2.0
                              )
                            ),
                          ),
                          Container(
                            width: 9.0 * animValues[0],
                            height: 9.0 * animValues[0],
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ]
                      ),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text('CustomRadio')
                  )
                ]
              );
            },
          ),
        ],
      ),
    );
  }

}