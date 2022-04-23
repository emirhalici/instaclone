import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyModel {
  String userUUID;
  List<dynamic> likes;
  String reply;
  Timestamp timestamp;

  ReplyModel({
    required this.userUUID,
    required this.likes,
    required this.reply,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'userUUID': userUUID,
        'reply': reply,
        'likes': likes,
        'timestamp': timestamp,
      };

  ReplyModel.fromJson(Map<String, dynamic> json)
      : userUUID = json['userUUID'] as String,
        likes = json['likes'] as List<dynamic>,
        reply = json['reply'] as String,
        timestamp = json['timestamp'] as Timestamp;

  static List<ReplyModel> repliesFromJson(List json) {
    List<ReplyModel> list = <ReplyModel>[];
    for (var item in json) {
      list.add(ReplyModel.fromJson(item));
    }
    return list;
  }

  static List<Map<String, dynamic>> replyListToJson(List<ReplyModel> replies) {
    List<Map<String, dynamic>> list = [];
    for (var reply in replies) {
      list.add(reply.toJson());
    }
    return list;
  }
}
