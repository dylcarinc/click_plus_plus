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

  @override
  void initState() {
    super.initState();
    _loadScore();
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

  

  @override
  Widget build(BuildContext context) {
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
          PopupMenuButton<String>(
              icon:  const Icon(Icons.settings),
              onSelected: (String result) {
                  // Handle menu item selection
                  switch (result) {
                    case 'profilePage':
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
                      break;
                    case 'option2':
                      // Handles option 2
                      break;
                  }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'profilePage',
                    child: Text('Profile'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'option2',
                    child: Text('Option 2'),
                  )
              ]
          )
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _incrementScore,
          child: const Text('Increment Score'),
        ),
      ),
    );
  }
}
