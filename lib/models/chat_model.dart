import 'package:instaclone/models/message_model.dart';
import 'package:instaclone/models/user_model.dart';

class ChatModel {
  List<dynamic> userUUIDs;
  List<MessageModel> messages;
  List<UserModel>? users;
  String documentId;

  ChatModel({
    required this.userUUIDs,
    required this.messages,
    this.users,
    required this.documentId,
  });

  Map<String, dynamic> toJson() => {
        'userUUIDs': userUUIDs,
        'messages': MessageModel.messageListToJson(messages),
      };

  ChatModel.fromJson(Map<String, dynamic> json, this.users, this.documentId)
      : userUUIDs = json['userUUIDs'],
        messages = MessageModel.messagesFromJson(json['messages']);

  @override
  String toString() {
    return 'users: ${userUUIDs.toString()}, messages: ${messages.toString()}';
  }
}
