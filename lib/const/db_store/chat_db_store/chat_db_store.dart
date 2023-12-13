import 'package:hive/hive.dart';

class ChatDBStore {
  late Box _chat;
  final String chatId;
  ChatDBStore({required this.chatId}) {
    _openCollection();
  }

  void _openCollection() async {
    if (Hive.isBoxOpen(chatId)) {
      _chat = Hive.box(chatId);
    } else {
      _chat = await Hive.openBox(chatId);
    }
  }

  Future<void> saveChatMessage({
    required Map<String, dynamic> savedValue,
  }) async {
    if (savedValue.isNotEmpty) {
      await _chat.add(savedValue);
    }
  }

  dynamic getChatMessages() {
    return _chat.values.toList();
  }

  Future<void> deleteChat() async {
    await _chat.clear();
  }

  void closeCollection() async {
    Hive.close();
  }
}
