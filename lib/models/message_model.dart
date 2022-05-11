import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String message;
  String senderUUID;
  Timestamp timestamp;
  String? postDocId;

  MessageModel({
    required this.message,
    required this.senderUUID,
    required this.timestamp,
    this.postDocId,
  });

  Map<String, dynamic> toJson() => {
        'message': message,
        'senderUUID': senderUUID,
        'timestamp': timestamp,
        'postDocId': postDocId ?? '',
      };

  MessageModel.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String,
        senderUUID = json['senderUUID'] as String,
        timestamp = json['timestamp'] as Timestamp,
        postDocId = json['postDocId'] ?? '';

  static List<Map<String, dynamic>> messageListToJson(List<MessageModel> messages) {
    List<Map<String, dynamic>> list = [];
    for (var message in messages) {
      list.add(message.toJson());
    }
    return list;
  }

  static List<MessageModel> messagesFromJson(List<dynamic> json) {
    List<MessageModel> messages = <MessageModel>[];
    for (var item in json) {
      messages.add(MessageModel.fromJson(item));
    }
    return messages;
  }
}
