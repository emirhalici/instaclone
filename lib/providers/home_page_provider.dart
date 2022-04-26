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
  Stream<List<List<PostModel>>>? postsStream;

  void setUser(User? user) {
    loggedInUser = user;
  }

  Future<Map<String, dynamic>> getUserWithUserUUID(String userUUID) async {
    var snapshot = await firestore.collection('users').where('userUUID', isEqualTo: userUUID).get();
    return snapshot.docs[0].data();
  }

  Future<void> getPostsStreamForMainPage() async {
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

    postsStream = firestore.collection('posts').where('userUUID', whereIn: followingUUIDs).snapshots().asyncMap(
          (snapshot) => Future.wait([getUserForPost(snapshot)]),
        );
    notifyListeners();
  }

  Future<List<PostModel>> getUserForPost(QuerySnapshot<Map<String, dynamic>> snapshot) async {
    List<PostModel> posts = [];
    for (var doc in snapshot.docs) {
      var data = doc.data();
      var user = await getUserWithUserUUID(data['userUUID']);
      posts.add(PostModel.fromJson(data, user, doc.id));
    }
    return posts;
  }
}
