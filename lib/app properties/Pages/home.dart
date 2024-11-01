
import 'dart:async';
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
  DateTime _dateTime = DateTime.now();
  int _lastClick = 0;
  int colorIndex = 0;
  int _score = 0;
  int currentMultiplier = 1;
  int multProgress = 0; // Current progress towards a multiplier
  int multGoal = 100; // Goal for multProgress
  String _name = "";
  double size = 240;
  double margin = 20;

  List<Color> colors = [
    Colors.black,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Color.fromARGB(255, 8, 121, 136),
    Colors.pink
  ];
  bool _isChanged = false;
  late List<Widget> stackChildren;

  Timer _resetTimer = Timer(Duration.zero, (){});
  late Timer _colorTimer;
  @override
  void initState() {
    super.initState();
    _colorTimer = Timer.periodic(const Duration(milliseconds: 50), nextColor);
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
    ];
  }


  void nextColor(Timer timer) async{
    setState(() {
      if(currentMultiplier > 1) {
        colorIndex = colorIndex + 1;
        if(colorIndex >= colors.length) {
          colorIndex = 1;
        }
      } else {
        colorIndex = 0;
      }
    });
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
        _dateTime = DateTime.now();
        _lastClick = _dateTime.millisecondsSinceEpoch;
        _resetTimer.cancel();
        _resetTimer = Timer.periodic(Duration(milliseconds: 200), (Timer timer) { // Set timer to reset current multiplier progress
          setState(() {
            _dateTime = DateTime.now();
            int _timeDif = _dateTime.millisecondsSinceEpoch - _lastClick;
            int lossMultiplier = (_timeDif / 1000).floor();
            multProgress = multProgress - (1  + lossMultiplier);
            if(multProgress < 0) {
              if(currentMultiplier > 1) {
                multProgress = 99;
                currentMultiplier -= 1;
              } else {
                multProgress = 0;
              }
            }
          });
        });

        multProgress++;
        if(multProgress > multGoal) {
          currentMultiplier += 1;
          multProgress = 0;
        }


          _score += currentMultiplier;
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
    int _size = size.toInt();
    int _margin = margin.toInt();
    _size += _margin;
    Random random = Random();
    double random_x = (random.nextInt(_size - 60) + 20 ).toDouble();
    double random_y = (random.nextInt(_size - 60) + 20).toDouble();
    //x1 is the center of the circle, x2 is the point.
    num item = random_y - (_size / 2);
    num item2 = random_x - (_size / 2);
    item = pow(item, 2);
    item2 = pow(item2, 2);
    double distance = sqrt(item + item2);
    double radius = (size / 2) + 10; //the + 10 is for the animated icon size.
    // print("Distance: ${distance}");
    // print("Radius: ${radius}");

    //this ensures that the spawn location is outside the circle but within the containter.
    while (distance < radius) {
      random_x = (random.nextInt(_size - 60) + 20).toDouble();
      random_y = (random.nextInt(_size - 60) + 20).toDouble();
      //x1 is the center of the circle, x2 is the point.
      item = random_y - (_size / 2);
      item2 = random_x - (_size / 2);
      item = pow(item, 2);
      item2 = pow(item2, 2);
      distance = sqrt(item + item2);
      // print("Distance: ${distance}");
      // print("Radius: ${radius}");
    }
    // print("X: ${random_x}");
    // print("Y: ${random_y}");

    //this section helps the icons spawn more evenly around the button
    int a = random.nextInt(10);
    if (a > 5) {
      stackChildren.add(Positioned(
          top: random_y, left: random_x, child: CustomAnimatedIcon()));
    } else {
      stackChildren.add(Positioned(
          bottom: random_y, right: random_x, child: CustomAnimatedIcon()));
    }
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
            Container(width: multProgress.toDouble() * 3,height: 50,decoration: BoxDecoration(color: colors[colorIndex], border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(10))),
            Text(
              "Current Multiplier: $currentMultiplier!",
              textScaler: TextScaler.linear(currentMultiplier.toDouble()),
              style: TextStyle(color: colors[colorIndex]),
            )
          ],
        ),
      ),
    );
  }
}

extension on Future<DocumentSnapshot<Map<String, dynamic>>> {
  data() {}
}
