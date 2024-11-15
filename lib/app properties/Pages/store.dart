import 'package:click_plus_plus/firebase_interface.dart';
import 'package:click_plus_plus/widgets/animation_purchasing_widget.dart';
import 'package:click_plus_plus/widgets/custom_animated_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Store extends StatefulWidget {
  final Function(CustomAnimatedIcon) onIconUpdate;
  final Function(int) onPointUpdate;
  final Function(CustomAnimatedIcon) onPurchase;
  final int points;
  final List<CustomAnimatedIcon> purchasedIcons;
  final List<CustomAnimatedIcon> allIcons;

  const Store({
    Key? key,
    required this.onIconUpdate,
    required this.points,
    required this.onPointUpdate,
    required this.onPurchase,
    required this.purchasedIcons,
    required this.allIcons,
  }) : super(key: key);

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  late int _currentPoints;

  @override
  void initState() {
    super.initState();
    _currentPoints = widget.points;
  }

  void _handlePurchase(CustomAnimatedIcon icon) {
    if (_currentPoints >= icon.price) {
      widget.onPurchase(icon);
      widget.onIconUpdate(icon);
      setState(() {
        _currentPoints -= icon.price;
      });

      _savePurchasedAnimations();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough coins or already purchased!'),
        ),
      );
    }
  }

  Future<void> _savePurchasedAnimations() async {
    final user = firebase.authInstance.currentUser;
    if (user != null) {
      List<String> purchasedAnimationNames = widget.purchasedIcons.map((icon) => icon.name).toList();
      await firebase.firestoreInstance.collection('users').doc(user.uid).set({
        'purchasedAnimations': purchasedAnimationNames,
        'points': _currentPoints,
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        title: const Text(
          'Shop',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.yellow, size: 28),
                const SizedBox(width: 4),
                Text(
                  '$_currentPoints', 
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.allIcons.length,
              itemBuilder: (context, index) {
                final icon = widget.allIcons[index];
                return AnimationPurchasingWidget(
                  icon: icon,
                  isPurchased: widget.purchasedIcons.contains(icon),
                  onPurchase: () {
                    _handlePurchase(icon); 
                  },
                  onEquip: () {
                    widget.onIconUpdate(icon);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${icon.name} equipped!')),
                    );
                  },
                  points: _currentPoints, 
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
