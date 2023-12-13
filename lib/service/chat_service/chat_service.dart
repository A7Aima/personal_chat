import 'package:PersonalChat/const/config/config.dart';
import 'package:PersonalChat/const/db_store/chat_db_store/chat_db_store.dart';
import 'package:PersonalChat/const/local_data/local_data.dart';
import 'package:PersonalChat/model/chat_val_model/chat_val_model.dart';
import 'package:PersonalChat/model/user_model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final db = FirebaseFirestore.instance;
  final String? chatId;
  late ChatDBStore _chatDBStore;
  List<ChatValModel> chatMessages = [];
  ChatService({this.chatId}) {
    _chatDBStore = ChatDBStore(chatId: chatId ?? "");
  }

  Future<Map<String, dynamic>?> createChatRoom({
    required String chatName,
    required String creatorId,
    required String creatorName,
  }) async {
    final result = await db.collection(Config.chatCollection).add({
      "chatName": chatName,
      "creatorId": creatorId,
      "creatorName": creatorName,
    });
    await result.update({"chatId": result.id});
    final document = await result.get();
    return document.data();
  }

  Future<void> saveChatRoomInUser({
    required String userId,
    Map<String, dynamic> chatDetails = const {},
  }) async {
    final result = await db.collection(Config.userCollection).doc(userId);
    await result.update({
      "chatListId": FieldValue.arrayUnion([chatDetails])
    });
  }

  Future<void> getUserDetails() async {
    try {
      if (LocalData().userModel != null) {
        final result = await db
            .collection(Config.userCollection)
            .doc(LocalData().userModel?.userId ?? "");
        final document = await result.get();
        final userMap = document.data() ?? {};
        LocalData().userModel = UserModel.fromJson(userMap);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<Map<String, dynamic>?> joinChatRoom({
    required String chatID,
    required String inviteId,
    required String inviteName,
  }) async {
    final result = await db.collection(Config.chatCollection).doc(chatID);
    final document = await result.get();
    final data = document.data();
    if (data != null) {
      if (data['creatorId'] == inviteId) {
        throw ("Same User Can't join again");
      } else if (data['inviteId'] == null) {
        await result.update({
          "inviteId": inviteId,
          "inviteName": inviteName,
        });
        return data;
      } else {
        throw ("Someone already accepted the invitation");
      }
    }
    throw ("Chat data you'r trying to join is unavailable");
  }

  Future<Map<String, dynamic>> getChatDetails({required String chatId}) async {
    final result = await db.collection(Config.chatCollection).doc(chatId);
    final document = await result.get();
    final data = document.data() ?? {};
    return data;
  }

  Future<dynamic> getChatMesagesFromLocal() async {
    final result = await _chatDBStore.getChatMessages();
    return result;
  }

  Future<void> setMessage({required ChatValModel model}) async {
    await _chatDBStore.saveChatMessage(savedValue: model.toMap());
  }

  Future<void> deleteChatCollection() async {
    await _chatDBStore.deleteChat();
  }
}
