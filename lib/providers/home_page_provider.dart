import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/chat_model.dart';
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
  Stream<List<ChatModel>>? chatsStream;
  Stream<ChatModel>? specifiedChatStream;
  List<UserModel>? followingUserModels;

  void setUser(User? user) {
    loggedInUser = user;
  }

  Future<UserModel> getUserWithUserUUID(String userUUID) async {
    var snapshot = await firestore.collection('users').where('userUUID', isEqualTo: userUUID).get();
    return UserModel.fromJson(snapshot.docs[0].data(), snapshot.docs[0].id);
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

  Future<void> getChatsStream() async {
    chatsStream ??= firestore.collection('chats').where('userUUIDs', arrayContains: userModel?.userUUID ?? '-1').snapshots().asyncMap(
      (snapshot) async {
        List<ChatModel> chats = [];
        for (var doc in snapshot.docs) {
          List<UserModel> users = [];
          for (var userUUID in doc.data()['userUUIDs']) {
            if (userUUID != userModel?.userUUID && userUUID != '') {
              var user = await getUserWithUserUUID(userUUID);
              users.add(user);
            }
          }
          ChatModel chat = ChatModel.fromJson(doc.data(), users, doc.id);
          chats.add(chat);
        }
        return chats;
      },
    );
  }

  Future<void> getSpecifiedChatStream(String documentId) async {
    specifiedChatStream = firestore.collection('chats').doc(documentId).snapshots().asyncMap((snapshot) async {
      List<UserModel> users = [];
      for (var userUUID in snapshot.data()!['userUUIDs']) {
        if (userUUID != userModel?.userUUID && userUUID != '') {
          var user = await getUserWithUserUUID(userUUID);
          users.add(user);
        }
      }
      return ChatModel.fromJson(snapshot.data()!, users, documentId);
    });
  }

  Future<bool> writeToChatModel(ChatModel chatModel) async {
    bool isSuccess = false;
    await firestore.collection('chats').doc(chatModel.documentId).update(chatModel.toJson()).then(((value) {
      isSuccess = true;
    })).catchError((error) {
      isSuccess = false;
    });
    return isSuccess;
  }

  Future<String> writeNewChatModel(ChatModel chatModel) async {
    try {
      var ref = await firestore.collection('chats').add(chatModel.toJson());
      return ref.id;
    } catch (e) {
      return '';
    }
  }

  Future<void> getFollowingUsersForNewChat() async {
    if (userModel == null) {
      await getUserStream();
    }

    List<UserModel> followingUsers = [];
    List followingExceptSelf = userModel!.following;
    if (followingExceptSelf.contains(userModel?.userUUID)) {
      followingExceptSelf.remove(userModel?.userUUID);
    }
    await firestore.collection('users').where('userUUID', whereIn: userModel?.following).get().then((value) {
      var docs = value.docs;
      for (var doc in docs) {
        UserModel user = UserModel.fromJson(doc.data(), doc.id);
        followingUsers.add(user);
      }
      followingUserModels = followingUsers;
      notifyListeners();
    });
  }
}
