import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/post_model.dart';

class PostsProvider with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> writePost(PostModel postModel) async {
    var collection = await firestore
        .collection('posts')
        .doc(postModel.documentId)
        .update(postModel.toJson())
        .then((value) => print('updated'))
        .catchError((error) => print('Update failed: $error'));
  }
}
