import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:click_plus_plus/app properties/routing/app_router.dart';
import 'package:click_plus_plus/firebase_interface.dart';

class ScoreboardScreen extends StatelessWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Scoreboard'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'All Users'),
                  Tab(text: 'Following'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildScoreList(false),
                _buildScoreList(true),
              ],
            ),
          ),
        ));
  }

  Widget _buildScoreList(bool onlyFollowing) {
    final currentUser = firebase.authInstance.currentUser;
    if (currentUser == null) {
      return const Center(
          child: Text('You must be logged in to view the scoreboard.'));
    }
    return StreamBuilder<QuerySnapshot>(
      stream: firebase.firestoreInstance
          .collection('users')
          .orderBy('score', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return FutureBuilder<List<String>>(
          future: _getFollowingList(currentUser.uid),
          builder: (context, followingSnapshot) {
            if (followingSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final followingList = followingSnapshot.data ?? [];

            final filteredDocs = snapshot.data!.docs.where((doc) {
              if (!onlyFollowing) return true;
              return followingList.contains(doc.id);
            }).toList();

            return ListView.builder(
              itemCount: filteredDocs.length,
              itemBuilder: (context, index) {
                final doc = filteredDocs[index];
                final data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  leading: UserAvatar(),
                  title: Text(data['name'] ?? 'Anonymous'),
                  trailing: Text(data['score'].toString()),
                  onTap: () => AppRouter.navigateTo(
                    context,
                    AppRouter.userProfile,
                    arguments: {'userId': doc.id},
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<List<String>> _getFollowingList(String userId) async {
    final followingDoc = await firebase.firestoreInstance
        .collection('users')
        .doc(userId)
        .collection('following')
        .get();
    return followingDoc.docs.map((doc) => doc.id).toList();
  }
}
