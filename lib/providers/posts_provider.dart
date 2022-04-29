import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/models/post_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PostsProvider with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> writePost(PostModel postModel) async {
    bool isSuccess = false;
    await firestore.collection('posts').doc(postModel.documentId).update(postModel.toJson()).then(((value) {
      isSuccess = true;
    })).catchError((error) {
      isSuccess = false;
    });
    return isSuccess;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUsersForComments(PostModel postModel) async {
    List<String> usersUUIDs = [];
    for (var element in postModel.comments) {
      usersUUIDs.add(element.userUUID);
    }
    var snapshot = await firestore.collection('users').where('userUUID', whereIn: usersUUIDs).get();
    return snapshot;
  }

  Future<String> uploadImage(XFile image) async {
    // TODO : URGENT
    // TODO : ADD RANDOM UID
    String filePath = 'postPics/${image.path.split("/").last}';
    TaskSnapshot uploadTask = await firebase_storage.FirebaseStorage.instance.ref(filePath).putFile(File(image.path));
    if (uploadTask.state == TaskState.error) {
      return '';
    }
    return await uploadTask.ref.getDownloadURL();
  }

  Future<bool> addNewPost(PostModel postModel) async {
    bool isSuccess = false;
    await firestore.collection('posts').add(postModel.toJson()).then(((value) {
      isSuccess = true;
    })).catchError((error) {
      isSuccess = false;
    });
    return isSuccess;
  }
}
