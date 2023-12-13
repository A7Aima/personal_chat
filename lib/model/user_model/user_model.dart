class UserModel {
  final userId;
  final name;
  final email;
  final chatListId;

  UserModel({
    this.userId,
    this.name,
    this.email,
    this.chatListId,
  });

  factory UserModel.fromJson(Map<dynamic, dynamic> parseJson) {
    return UserModel(
      userId: parseJson['userId'],
      name: parseJson['name'],
      email: parseJson['email'],
      chatListId: parseJson['chatListId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "name": name,
      "email": email,
      "chatListId": chatListId,
    };
  }
}
