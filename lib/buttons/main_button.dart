import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// This code is the initial implmentation of the +Button
class MainButton extends StatefulWidget {
  final Function(int) onCountChanged;

  const MainButton({Key? key, required this.onCountChanged}) : super(key: key);

  @override
  _MainButtonState createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  int _count = 0;

  void _incrementCount() {
    setState(() {
      _count++;
      widget.onCountChanged(_count);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _incrementCount,
      child: const Text('Increment Count'),
    );
  }
}



