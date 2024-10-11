import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainButton extends StatefulWidget {
  @override
  _MainButtonState createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  int _userCount = 0;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  

}



