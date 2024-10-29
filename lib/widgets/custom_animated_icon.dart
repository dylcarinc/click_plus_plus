import 'package:flutter/material.dart';

class CustomAnimatedIcon extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CustomAnimatedIconState();
  }
}

class CustomAnimatedIconState extends State<CustomAnimatedIcon>
    with TickerProviderStateMixin {
  late AnimationController _movementController;
  late AnimationController _opacityController;

  @override
  void initState() {
    super.initState();

    _movementController = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
        lowerBound: 0.0,
        upperBound: 20.0);

    _movementController
        .forward(); //default goes from 0 to 1. I think I have it set to go from 0 to 10.

    _movementController.addListener(() {
      // print(_movementController.value);
    });
    _movementController.addStatusListener((status) {
      // print(status);
    });

    _opacityController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _opacityController.forward();

    _opacityController.addListener(() {
      // if (_opacityController.value > 0.5) {
      //   _opacityController.reverse();
      // }
    });

    _opacityController.addStatusListener((status) {
      print(status);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _movementController,
      child: const Icon(Icons.add, color: Colors.red, size: 20),
      builder: (BuildContext context, child) {
        return Opacity(
          opacity: 1 - _opacityController.value,
          child: Transform.translate(
            offset: Offset(0.0, _movementController.value * -1),
            child: child,
          ),
        );
      },
    );
  }
}
