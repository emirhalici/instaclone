import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/post_model.dart';
import 'package:instaclone/models/user_model.dart';

class HomePageProvider with ChangeNotifier {
  PageController pageController = PageController(initialPage: 0);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? loggedInUser;
  List<String> followingUUIDs = [];
  Stream<List<List<PostModel>>>? postsStream;
  Stream? userStream;
  ScrollController mainPostsController = ScrollController();
  UserModel? userModel;

  void setUser(User? user) {
    loggedInUser = user;
  }

  Future<Map<String, dynamic>> getUserWithUserUUID(String userUUID) async {
    var snapshot = await firestore.collection('users').where('userUUID', isEqualTo: userUUID).get();
    return snapshot.docs[0].data();
  }

  Future<void> getPostsStreamForMainPage() async {
    if (userStream == null) {
      await getUserStream();
    }

    userStream?.listen((snapshot) {
      UserModel user = UserModel.fromJson(snapshot.docs[0].data(), snapshot.docs[0].id);
      userModel = user;
      if (user.following.isEmpty) {
        postsStream = null;
      } else {
        List following = user.following;
        following.add(user.userUUID);
        postsStream =
            firestore.collection('posts').where('userUUID', whereIn: following).orderBy('timestamp', descending: true).snapshots().asyncMap(
          (snapshot) {
            return Future.wait([getUserForPost(snapshot)]);
          },
        );
      }

      notifyListeners();
    });
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

  Future<void> getUserStream() async {
    if (userStream == null) {
      userStream = firestore.collection('users').where('userUUID', isEqualTo: loggedInUser?.uid).snapshots();
      userStream?.listen(
        (snapshot) {
          userModel = UserModel.fromJson(snapshot.docs[0].data(), snapshot.docs[0].id);
        },
      );
      notifyListeners();
    }
  }
}
