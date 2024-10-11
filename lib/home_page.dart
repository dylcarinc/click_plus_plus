import 'package:firebase_auth/firebase_auth.dart' // new
    hide EmailAuthProvider, PhoneAuthProvider;    // new
import 'package:flutter/material.dart';           // new
import 'package:provider/provider.dart';          // new



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cick++")),
      body: const Column(
        children: [Row(
          children: [Positioned(top: 10, left: 10, child: IconButton(onPressed: null, icon: Icon(Icons.settings))),
          
          ],
          )
        ],
      )
    );

  }



}