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
  String username = '';
  ScrollController userProfileScrollController = ScrollController();
  ScrollController anotherUserProfileScrollController = ScrollController();
  bool isUserPostsEmpty = false;
  bool isAnotherUserPostsEmpty = false;
  Stream<List<PostModel>>? userPostsStream;
  Stream<List<PostModel>>? anotherUserPostsStream;
  int userPostsCount = 0;
  int anotherUserPostsCount = 0;

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

  Future<void> getUserPostsStream() async {
    if (userPostsStream == null) {
      userPostsStream = firestore
          .collection('posts')
          .where('userUUID', isEqualTo: loggedInUser!.uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .asyncMap(
        (snapshot) {
          List<PostModel> posts = [];
          for (var doc in snapshot.docs) {
            PostModel post = PostModel.fromJson(doc.data(), userData, doc.id);
            posts.add(post);
          }
          return posts;
        },
      );
      notifyListeners();
    }
  }

  Future<void> getAnotherUserPostsStream(String userUUID) async {
    if (anotherUserPostsStream == null) {
      anotherUserPostsStream =
          firestore.collection('posts').where('userUUID', isEqualTo: userUUID).orderBy('timestamp', descending: true).snapshots().asyncMap(
        (snapshot) {
          List<PostModel> posts = [];
          for (var doc in snapshot.docs) {
            PostModel post = PostModel.fromJson(doc.data(), anotherUserData, doc.id);
            posts.add(post);
          }
          return posts;
        },
      );
      notifyListeners();
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

  Future<bool> writeUser(UserModel userModel) async {
    bool isSuccess = false;
    await firestore.collection('users').doc(userModel.docId).update(userModel.toJson()).then(((value) {
      isSuccess = true;
    })).catchError((error) {
      isSuccess = false;
    });
    return isSuccess;
  }

  void setUserPostsCount(int length) {
    userPostsCount = length;
    notifyListeners();
  }

  void setAnotherUserPostsCount(int length) {
    anotherUserPostsCount = length;
    notifyListeners();
  }
}
