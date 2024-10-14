import 'package:flutter/material.dart';

// This is the intial code for the navigation/score keeping button
class PageButton extends StatelessWidget {
  final int count;
  final VoidCallback onNextPage;

  const PageButton({
    Key? key,
    required this.count,
    required this.onNextPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onNextPage,
      child: Text('Total Count: $count'),
    );
  }
}