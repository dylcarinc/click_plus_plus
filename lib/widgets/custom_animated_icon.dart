import 'package:flutter/material.dart';

class CustomAnimatedIcon extends StatefulWidget {
  final Color color;
  final String name;
  final IconData shape;
  final int price;
  final bool purchased;
  

  const CustomAnimatedIcon({
    super.key,
    required this.color, 
    required this.name, 
    required this.shape, 
    required this.price,
    required this.purchased
    
  });

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
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _movementController,
      child: Icon(widget.shape, color: widget.color, size: 20),
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
