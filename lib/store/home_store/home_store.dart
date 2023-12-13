import 'package:PersonalChat/const/local_data/local_data.dart';
import 'package:PersonalChat/model/chat_list_model/chat_list_model.dart';
import 'package:PersonalChat/service/chat_service/chat_service.dart';
import 'package:PersonalChat/service/user_service/user_service.dart';

class HomeStore {
  ChatService chatService = ChatService();
  UserLocalService userService = UserLocalService();

  List<ChatListModel> chatList = [];

  String chatName = '';

  String joinId = '';

  String? errorMessage;

  bool isLoading = false;

  Future<void> getUserDetails() async {
    try {
      await chatService.getUserDetails();
      chatList.clear();
      ((LocalData().userModel?.chatListId ?? []) as List<dynamic>)
          .forEach((parseJson) {
        chatList.add(ChatListModel.fromJson(parseJson));
      });
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Future<void> createChatRoom() async {
    try {
      final result = await chatService.createChatRoom(
        chatName: chatName,
        creatorId: LocalData().userModel?.userId ?? "",
        creatorName: LocalData().userModel?.name ?? "",
      );
      final addChat = ChatListModel.fromJson(result ?? {});
      await chatService.saveChatRoomInUser(
        userId: LocalData().userModel?.userId ?? "",
        chatDetails: addChat.toMap(),
      );
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Future<void> joinChatRoom() async {
    try {
      final result = await chatService.joinChatRoom(
        chatID: joinId,
        inviteId: LocalData().userModel?.userId ?? "",
        inviteName: LocalData().userModel?.name ?? "",
      );
      final addChat = ChatListModel.fromJson(result ?? {});
      await chatService.saveChatRoomInUser(
        userId: LocalData().userModel?.userId ?? "",
        chatDetails: addChat.toMap(),
      );
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }
  }
}
