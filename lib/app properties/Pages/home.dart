import 'dart:math';

import 'package:click_plus_plus/app%20properties/theme_provider.dart';
import 'package:click_plus_plus/widgets/custom_animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:click_plus_plus/app properties/routing/app_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:click_plus_plus/firebase_interface.dart';
import 'package:click_plus_plus/widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _score = 0;
  String _name = "";
  double size = 240;
  double margin = 20;
  bool _isChanged = false;
  late List<Widget> stackChildren;

  @override
  void initState() {
    super.initState();
    _loadScore();
    _getName();
    stackChildren = [
      Container(
        color: Colors.white10,
        height: size,
        width: size,
      ),
      Positioned(
        bottom: margin,
        left: margin,
        right: margin,
        top: margin,
        child: CustomRoundButton(
          onPressed: () {
            final myController = TextEditingController();
            if (_name == "false" || _name == "") {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Please enter your name."),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: myController,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _setName(myController.text);
                          Navigator.pop(context);
                        },
                        child: const Text("Set Name"),
                      )
                    ],
                  ),
                ),
              );
            } else {
              _incrementScore();
              _spawnIcon();
            }
          },
          size: 150, // You can adjust the size as needed
        ),
      ),
      Positioned(
          top: 115,
          bottom: 115,
          left: 115,
          right: 115,
          child: Container(
            color: Colors.orange,
            height: 5,
            width: 5,
          ))
    ];
  }

  Future<void> _loadScore() async {
    final user = firebase.authInstance.currentUser;
    if (user != null) {
      final doc = await firebase.firestoreInstance
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
    final user = firebase.authInstance.currentUser;
    if (user != null) {
      final doc = await firebase.firestoreInstance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists && doc.data()?['name'] != null) {
        setState(() {
          _name = doc.data()?['name'] ?? "";
        });
      } else {
        setState(() {
          _name = "false";
        });
      }
    } else {
      setState(() {
        _name = "false";
      });
    }
  }

  Future<void> _incrementScore() async {
    final user = firebase.authInstance.currentUser;
    if (user != null) {
      setState(() {
        _score++;
      });
      await firebase.firestoreInstance.collection('users').doc(user.uid).set({
        'score': _score,
      }, SetOptions(merge: true));
    }
  }

  Future<void> _setName(String name) async {
    final user = firebase.authInstance.currentUser;
    if (user != null) {
      await firebase.firestoreInstance.collection('users').doc(user.uid).set({
        'name': name,
      }, SetOptions(merge: true));
      _name = name;
    }
  }

  void _spawnIcon() {
    int _size = size as int;
    int _margin = margin as int;
    _size += _margin;
    Random random = Random();
    double random_x = random.nextInt(_size - 60) + 20 as double;
    double random_y = random.nextInt(_size - 60) + 20 as double;
    //x1 is the center of the circle, x2 is the point.
    num item = random_y - (_size / 2);
    num item2 = random_x - (_size / 2);
    item = pow(item, 2);
    item2 = pow(item2, 2);
    double distance = sqrt(item + item2);
    double radius = (size / 2);
    print("Distance: ${distance}");
    print("Radius: ${radius}");
    while (distance < radius) {
      random_x = random.nextInt(_size - 60) + 20 as double;
      random_y = random.nextInt(_size - 60) + 20 as double;
      //x1 is the center of the circle, x2 is the point.
      item = random_y - (_size / 2);
      item2 = random_x - (_size / 2);
      item = pow(item, 2);
      item2 = pow(item2, 2);
      distance = sqrt(item + item2);
      // radius = size - margin;
      print("Distance: ${distance}");
      print("Radius: ${radius}");
    }
    print("X: ${random_x}");
    print("Y: ${random_y}");
    stackChildren.add(
        Positioned(top: random_y, left: random_x, child: CustomAnimatedIcon()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton(
            onPressed: () =>
                AppRouter.navigateTo(context, AppRouter.scoreboard),
            child: Text('$_score', style: const TextStyle(fontSize: 20)),
          ),
          PopupMenuButton(
              icon: const Icon(Icons.settings),
              onSelected: (String result) {
                // Handle menu item selection
                switch (result) {
                  case 'themeToggle':
                    break;

                  case 'MyAccount':
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
                                    ])));
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem(
                      value: 'themeToggle',
                      child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Theme'),
                              Switch(
                                value: _isChanged,
                                onChanged: (bool value) {
                                  setState(() {
                                    _isChanged = value;
                                  });
                                  Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .toggleTheme();
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'MyAccount',
                      child: Text('My Account'),
                    )
                  ])
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 40),
            Stack(
              children: stackChildren,
            ),
          ],
        ),
      ),
    );
  }
}

extension on Future<DocumentSnapshot<Map<String, dynamic>>> {
  data() {}
}
