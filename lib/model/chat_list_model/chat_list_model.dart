class ChatListModel {
  final chatId;
  final chatName;
  final creatorId;
  final creatorName;
  final inviteId;
  final inviteName;

  ChatListModel({
    this.chatId,
    this.chatName,
    this.creatorId,
    this.creatorName,
    this.inviteId,
    this.inviteName,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> parseJson) {
    return ChatListModel(
      chatId: parseJson['chatId'],
      chatName: parseJson['chatName'],
      creatorId: parseJson['creatorId'],
      creatorName: parseJson['creatorName'],
      inviteId: parseJson['inviteId'],
      inviteName: parseJson['inviteName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "chatId": chatId,
      "chatName": chatName,
      "creatorId": creatorId,
      "creatorName": creatorName,
      "inviteId": inviteId,
      "inviteName": inviteName,
    };
  }
}
