import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaclone/models/comment_model.dart';

class PostModel {
  List<dynamic> likes;
  List<dynamic> pictures;
  String description;
  String userUUID;
  List<CommentModel> comments;
  Timestamp timestamp;
  String username;

  PostModel({
    required this.likes,
    required this.pictures,
    required this.description,
    required this.userUUID,
    required this.comments,
    required this.timestamp,
    required this.username,
  });

  Map<String, dynamic> toJson() => {
        'likes': likes,
        'pictures': pictures,
        'description': description,
        'userUUID': userUUID,
        'comments': comments,
        'timestamp': timestamp,
      };

  PostModel.fromJson(Map<String, dynamic> json, this.username)
      : likes = json['likes'] as List<dynamic>,
        pictures = json['pictures'] as List<dynamic>,
        description = json['description'] as String,
        userUUID = json['userUUID'] as String,
        comments = CommentModel.repliesFromJson(json['comments']),
        timestamp = json['timestamp'] as Timestamp;
}
