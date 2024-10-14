import 'package:click_plus_plus/buttons/main_button.dart';
import 'package:firebase_auth/firebase_auth.dart' // new
    hide EmailAuthProvider, PhoneAuthProvider;    // new
import 'package:flutter/material.dart';           // new
import 'package:provider/provider.dart';
import 'package:click_plus_plus/buttons/page_button.dart';



class GamePage extends StatefulWidget {
  const GamePage({super.key});


  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // Total count is temporary, need to be able to pull firebase info
  int _totalCount = 0;

  void _updateTotalCount(int count) {
    setState(() {
      _totalCount = count;
    });
  }


void _NavigatePages() {
  // Just went ahead and made this for future use
}



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cick++")),
      body: Column(
        children: [Row(
          children: [
            // code for a pop up menu button
            PopupMenuButton<String>(
              icon:  const Icon(Icons.settings),
              onSelected: (String result) {
                  // Handle menu item selection
                  switch (result) {
                    case 'option1':
                      // Handles option 1
                      break;
                    case 'option2':
                      // Handles option 2
                      break;
                  }
                },
              // this section builds the items within the popup menu
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'option1',
                    child: Text('Option 1'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'option2',
                    child: Text('Option 2'),
                  ),
                ],
              ),
            ]
            ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MainButton(onCountChanged: _updateTotalCount),
                  const SizedBox(height: 20),
                  PageButton(
                    count: _totalCount,
                    onNextPage: _NavigatePages,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



