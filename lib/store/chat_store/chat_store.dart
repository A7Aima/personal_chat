import 'package:PersonalChat/const/config/config.dart';
import 'package:PersonalChat/model/chat_list_model/chat_list_model.dart';
import 'package:PersonalChat/model/chat_val_model/chat_val_model.dart';
import 'package:PersonalChat/service/chat_service/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatStore {
  final db = FirebaseFirestore.instance;
  final String chatId;
  ChatStore({required this.chatId}) {
    _chatService = ChatService(chatId: chatId);
  }
  late ChatService _chatService;

  ChatListModel chatModel = ChatListModel();
  List<ChatValModel> chatMessages = [];
  String? errorMessage;

  bool isLoading = false;

  Future<void> getChatDetail({required String chatId}) async {
    final result = await _chatService.getChatDetails(chatId: chatId);
    chatModel = ChatListModel.fromJson(result);
  }

  Future<void> getChatMesagesFromLocal() async {
    final result = await _chatService.getChatMesagesFromLocal();
    final messages = (result as List<dynamic>?) ?? [];
    chatMessages.clear();
    messages.forEach((element) {
      chatMessages.add(ChatValModel.fromJson(element));
    });
  }

  Future<void> sendMessage({required ChatValModel message}) async {
    await setMessageToLocal(message: message);
    await sendMessageToCollection(message: message);
  }

  Future<void> deleteMessagesFromLocal() async {
    await _chatService.deleteChatCollection();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatCollection() {
    return db
        .collection(Config.chatCollection)
        .doc(chatId)
        .collection(Config.chatSubCollection)
        .snapshots();
  }

  Future<void> sendMessageToCollection({required ChatValModel message}) {
    return db
        .collection(Config.chatCollection)
        .doc(chatId)
        .collection(Config.chatSubCollection)
        .doc(message.chatValId)
        .set(message.toMap());
  }

  Future<void> setMessageToLocal({required ChatValModel message}) async {
    await _chatService.setMessage(model: message);
  }

  Future<void> recievedMessage({required String chatValId}) async {
    await db
        .collection(Config.chatCollection)
        .doc(chatId)
        .collection(Config.chatSubCollection)
        .doc(chatValId)
        .update({'isRecieved': true});
  }

  Future<void> deleteMessage({required String chatValId}) async {
    await db
        .collection(Config.chatCollection)
        .doc(chatId)
        .collection(Config.chatSubCollection)
        .doc(chatValId)
        .delete();
  }
}
