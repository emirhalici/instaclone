import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/post_model.dart';

class HomePageProvider with ChangeNotifier {
  PageController pageController = PageController(initialPage: 0);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? loggedInUser;
  Map<String, dynamic>? userData;
  List<String> followingUUIDs = [];
  List<PostModel> allPosts = [];

  void setUser(User? user) {
    loggedInUser = user;
  }

  Future<void> getPostsForMainPage() async {
    List<PostModel> posts = [];

    if (userData == null) {
      final snapshot = await firestore.collection('users').where('userUUID', isEqualTo: loggedInUser?.uid).get();
      if (snapshot.docs.isNotEmpty) {
        userData = snapshot.docs[0].data();
      }
    }

    if (followingUUIDs.isEmpty && userData != null && userData!['following'] != null && userData?['following'] != null) {
      for (var followingUUID in userData!['following']) {
        followingUUIDs.add(followingUUID);
      }
      followingUUIDs.add(loggedInUser!.uid);
    }

    if (followingUUIDs.isEmpty) {
      throw 'Unexpected error: User not following anybody.';
    }

    var snapshot = await firestore.collection('posts').where('userUUID', whereIn: followingUUIDs).get();
    for (var doc in snapshot.docs) {
      var userSnapshot = await firestore.collection('users').where('userUUID', isEqualTo: doc.data()['userUUID']).get();
      posts.add(PostModel.fromJson(doc.data(), userSnapshot.docs[0].data(), doc.id));
    }
    allPosts = posts;
    notifyListeners();
  }
}
