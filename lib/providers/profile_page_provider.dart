import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaclone/models/post_model.dart';
import 'package:instaclone/models/user_model.dart';

class ProfilePageProvider with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? loggedInUser;
  Map<String, dynamic> userData = <String, dynamic>{};
  Map<String, dynamic> anotherUserData = <String, dynamic>{};
  UserModel? anotherUserModel;
  UserModel? userModel;
  List<PostModel> posts = [];
  List<PostModel> anotherUserPosts = [];
  String username = '';
  ScrollController pageScrollController = ScrollController();
  bool isUserPostsEmpty = false;
  bool isAnotherUserPostsEmpty = false;

  void setUser(User? user) {
    loggedInUser = user;
  }

  String? getCurrentUserUuid() {
    return loggedInUser?.uid;
  }

  Future<bool> getCurrentUserData() async {
    try {
      final snapshot = await firestore.collection('users').get();
      String uid = loggedInUser!.uid;
      final docs = snapshot.docs;
      for (var doc in docs) {
        Map<String, dynamic> data = doc.data();
        if (data['userUUID'] == uid) {
          userData = data;
          userModel = UserModel.fromJson(data, doc.id);
          username = data['username'];
        }
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> setUserUpAfterSignUp(Map<String, dynamic> json) async {
    try {
      await firestore.collection('users').add(json);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> getUserPosts() async {
    try {
      final snapshot = await firestore.collection('posts').where('userUUID', isEqualTo: loggedInUser!.uid).get();
      final docs = snapshot.docs;

      posts = [];

      for (var doc in docs) {
        Map<String, dynamic> data = doc.data();
        posts.add(PostModel.fromJson(data, userData, doc.id));
      }
      if (posts.isEmpty) {
        isUserPostsEmpty = true;
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getUserData(String userUUID) async {
    try {
      final snapshot = await firestore.collection('users').where('userUUID', isEqualTo: userUUID).get();
      final docs = snapshot.docs;
      for (var doc in docs) {
        Map<String, dynamic> data = doc.data();
        if (data['userUUID'] == userUUID) {
          anotherUserData = data;
          anotherUserModel = UserModel.fromJson(anotherUserData, doc.id);
        }
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getPosts(String userUUID) async {
    try {
      final snapshot = await firestore.collection('posts').where('userUUID', isEqualTo: userUUID).get();
      final docs = snapshot.docs;

      anotherUserPosts = [];

      for (var doc in docs) {
        Map<String, dynamic> data = doc.data();
        anotherUserPosts.add(PostModel.fromJson(data, anotherUserData, doc.id));
      }
      if (anotherUserPosts.isEmpty) {
        isAnotherUserPostsEmpty = true;
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> writeUser(UserModel userModel) async {
    bool isSuccess = false;
    await firestore.collection('users').doc(userModel.docId).update(userModel.toJson()).then(((value) {
      isSuccess = true;
    })).catchError((error) {
      isSuccess = false;
    });
    return isSuccess;
  }
}
