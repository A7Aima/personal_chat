class ChatValModel {
  final chatId;
  final chatValId;
  final senderName;
  final senderId;
  final message;
  final timeStamp;
  final bool isRecieved;

  ChatValModel({
    this.chatId,
    this.chatValId,
    this.senderName,
    this.senderId,
    this.message,
    this.timeStamp,
    this.isRecieved = false,
  });

  factory ChatValModel.fromJson(Map<dynamic, dynamic> parseJson) {
    return ChatValModel(
      chatId: parseJson['chatId'],
      chatValId: parseJson["chatValId"],
      senderName: parseJson["senderName"],
      senderId: parseJson["senderId"],
      message: parseJson["message"],
      timeStamp: parseJson["timeStamp"],
      isRecieved: parseJson["isRecieved"] ?? false,
    );
  }

  toMap() {
    return {
      "chatId": chatId,
      "chatValId": chatValId,
      "senderName": senderName,
      "senderId": senderId,
      "message": message,
      "timeStamp": timeStamp,
      "isRecieved": isRecieved,
    };
  }
}
