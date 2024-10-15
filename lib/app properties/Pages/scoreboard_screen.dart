import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:click_plus_plus/routing/app_router.dart';

class ScoreboardScreen extends StatelessWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
    );
  }

  Widget _buildScoreList(bool onlyFollowing) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Center(
          child: Text('You must be logged in to view the scoreboard.'));
    }
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
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
    final followingDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('following')
        .get();
    return followingDoc.docs.map((doc) => doc.id).toList();
  }
}
