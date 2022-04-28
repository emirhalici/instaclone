import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/post_model.dart';

class SearchPageProvider with ChangeNotifier {
  Stream<List<List<PostModel>>>? postsStream;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ScrollController searchPostsController = ScrollController();

  Future<void> getPostsStreamForSearchPage() async {
    postsStream = firestore.collection('posts').snapshots().asyncMap(
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

  Future<Map<String, dynamic>> getUserWithUserUUID(String userUUID) async {
    var snapshot = await firestore.collection('users').where('userUUID', isEqualTo: userUUID).get();
    return snapshot.docs[0].data();
  }
}
