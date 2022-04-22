import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePageProvider with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? loggedInUser;
  Map<String, dynamic> userData = <String, dynamic>{};

  void setUser(User? user) {
    loggedInUser = user;
  }

  String? getCurrentUserUuid() {
    return loggedInUser?.uid;
  }

  Future<void> getCurrentUserData() async {
    print(loggedInUser);
    final snapshot = await firestore.collection('users').get();
    String uid = loggedInUser!.uid;
    final docs = snapshot.docs;
    for (var doc in docs) {
      Map<String, dynamic> data = doc.data();
      if (data['userUUID'] == uid) {
        userData = data;
      }
    }
    notifyListeners();
  }
}
