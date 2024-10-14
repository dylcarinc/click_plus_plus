import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'scoreboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _score = 0;
  String _name = "";

  @override
  void initState() {
    super.initState();
    _loadScore();
    _getName();
  }

  Future<void> _loadScore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        setState(() {
          _score = doc.data()?['score'] ?? 0;
        });
      }
    }
  }
   Future<void> _getName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists && doc.data()?['name'] != null) {
        setState(() {
        _name = doc.data()?['name'] ?? "";});
      }
      else{
        setState(() {

        _name = "false";});
      }
    }
    else{
      setState(() {

        _name = "false";});
    }
  }

  Future<void> _incrementScore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _score++;
      });
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'score': _score,
      }, SetOptions(merge: true));
    }
  }
    Future<void> _setName(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
      }, SetOptions(merge: true));
      _name = name;
    }
  }


  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ScoreboardScreen()),
              );
            },
            child: Text('$_score', style: const TextStyle(fontSize: 20)),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('User Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final myController = TextEditingController();
            if(_name == "false" || _name == ""){
              showDialog(context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text("Please enter your name."),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                 children: [
                  TextField(
                    controller: myController,
                  ),
                  ElevatedButton(
                    onPressed:() => {
                    _setName(myController.text),
                    Navigator.pop(context)
                    }, 
                    child: const Text("Set Name"))
                 ]
                ),
                ));
            }
            else{
                  _incrementScore();
                }
          },
          child: const Text('Increment Score'),
        ),
      ),
    );
  }
}

extension on Future<DocumentSnapshot<Map<String, dynamic>>> {
  data() {}
}
