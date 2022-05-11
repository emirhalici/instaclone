class UserModel {
  List<dynamic> following;
  List<dynamic> followers;
  String description;
  String userUUID;
  String username;
  String name;
  String docId;
  String profilePic;

  UserModel({
    required this.following,
    required this.followers,
    required this.description,
    required this.userUUID,
    required this.username,
    required this.name,
    required this.docId,
    required this.profilePic,
  });

  Map<String, Object?> toJson() => {
        'following': following,
        'followers': followers,
        'description': description,
        'userUUID': userUUID,
        'username': username,
        'name': name,
        'profilePic': profilePic,
      };

  UserModel.fromJson(Map<String, dynamic> json, this.docId)
      : following = json['following'] as List<dynamic>,
        followers = json['followers'] as List<dynamic>,
        description = json['description'] as String,
        userUUID = json['userUUID'] as String,
        username = json['username'] as String,
        name = json['name'] as String,
        profilePic = json['profilePic'] ?? '';
}
