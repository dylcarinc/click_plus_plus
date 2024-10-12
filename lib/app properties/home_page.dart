import 'package:click_plus_plus/buttons/main_button.dart';
import 'package:firebase_auth/firebase_auth.dart' // new
    hide EmailAuthProvider, PhoneAuthProvider;    // new
import 'package:flutter/material.dart';           // new
import 'package:provider/provider.dart';
import 'package:click_plus_plus/buttons/page_button.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        children: [const Row(
          children: [
            Positioned(top: 10, left: 10, 
            child: IconButton(onPressed: null, 
            icon: Icon(Icons.settings))),
          ],
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
      )
    );
  }
}



