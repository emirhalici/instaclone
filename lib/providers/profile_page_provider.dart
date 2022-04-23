import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaclone/models/post_model.dart';

class ProfilePageProvider with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? loggedInUser;
  Map<String, dynamic> userData = <String, dynamic>{};
  List<PostModel> posts = [];
  String username = '';

  void setUser(User? user) {
    loggedInUser = user;
  }

  String? getCurrentUserUuid() {
    return loggedInUser?.uid;
  }

  Future<void> getCurrentUserData() async {
    try {
      final snapshot = await firestore.collection('users').get();
      String uid = loggedInUser!.uid;
      final docs = snapshot.docs;
      for (var doc in docs) {
        Map<String, dynamic> data = doc.data();
        if (data['userUUID'] == uid) {
          userData = data;
          username = data['username'];
        }
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> setUserUpAfterSignUp(Map<String, dynamic> json) async {
    try {
      final snapshot = await firestore.collection('users').add(json);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserPosts() async {
    print(userData);
    try {
      final snapshot = await firestore.collection('posts').where('userUUID', isEqualTo: loggedInUser!.uid).get();
      final docs = snapshot.docs;

      posts = [];

      for (var doc in docs) {
        Map<String, dynamic> data = doc.data();
        posts.add(PostModel.fromJson(data, userData, doc.id));
      }

      print('got all the posts');

      notifyListeners();
    } catch (e) {
      print(e);
      print('something went wrong');
    }
  }

  
}
