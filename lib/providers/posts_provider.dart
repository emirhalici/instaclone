import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/post_model.dart';

class PostsProvider with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> writePost(PostModel postModel) async {
    await firestore
        .collection('posts')
        .doc(postModel.documentId)
        .update(postModel.toJson())
        .catchError((error) => throw ('Update failed: $error'));
  }
}
