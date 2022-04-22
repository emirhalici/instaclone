import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaclone/models/reply_model.dart';

class CommentModel {
  String comment;
  List<dynamic> likes;
  String userUUID;
  List<ReplyModel> replies;
  Timestamp timestamp;

  CommentModel({
    required this.comment,
    required this.likes,
    required this.userUUID,
    required this.replies,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'comment': comment,
        'likes': likes,
        'userUUID': userUUID,
        'replies': replies,
        'timestamp': timestamp,
      };

  CommentModel.fromJson(Map<String, dynamic> json)
      : comment = json['comment'] as String,
        likes = json['likes'],
        userUUID = json['userUUID'] as String,
        replies = ReplyModel.repliesFromJson(json['replies']),
        timestamp = json['timestamp'] as Timestamp;

  static List<CommentModel> repliesFromJson(List json) {
    List<CommentModel> list = <CommentModel>[];
    for (var item in json) {
      list.add(CommentModel.fromJson(item));
    }
    return list;
  }
}
