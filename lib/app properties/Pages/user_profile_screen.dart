import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:click_plus_plus/firebase_interface.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _checkIfFollowing();
  }

  void _checkIfFollowing() async {
    final currentUser = firebase.authInstance.currentUser;
    if (currentUser != null) {
      final doc = await firebase.firestoreInstance
          .collection('users')
          .doc(currentUser.uid)
          .collection('following')
          .doc(widget.userId)
          .get();
      setState(() {
        _isFollowing = doc.exists;
      });
    }
  }

  void _toggleFollow() async {
    final currentUser = firebase.authInstance.currentUser;
    if (currentUser != null) {
      final followingRef = firebase.firestoreInstance
          .collection('users')
          .doc(currentUser.uid)
          .collection('following')
          .doc(widget.userId);

      if (_isFollowing) {
        await followingRef.delete();
      } else {
        await followingRef.set({
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
      setState(() {
        _isFollowing = !_isFollowing;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User not found'));
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data['name'] ?? 'Anonymous',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 20),
                Text('Score: ${data['score'] ?? 'N/A'}',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _toggleFollow,
                  child: Text(_isFollowing ? 'Unfollow' : 'Follow'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
