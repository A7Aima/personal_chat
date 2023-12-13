import 'dart:math';

import 'package:PersonalChat/const/local_data/local_data.dart';
import 'package:PersonalChat/model/chat_val_model/chat_val_model.dart';
import 'package:PersonalChat/store/chat_store/chat_store.dart';
import 'package:PersonalChat/utility/mixin/base_mixin/base_mixin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends BasePageWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends BaseState<ChatScreen> {
  late ChatStore _store;
  TextEditingController _messageController = TextEditingController();

  @override
  void initializeWithContext(BuildContext context) async {
    super.initializeWithContext(context);
    if (routesArguments.isNotEmpty) {
      _store = ChatStore(chatId: routesArguments['chatId']);
      await _getChatDetails(chatId: routesArguments['chatId']);
      // await _store.deleteMessagesFromLocal(); // for testing
      await _getChatMessages();
      _listenChatCollection();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Offstage(),
      appBar: AppBar(
        title: Text("${_store.chatModel.chatName ?? 'Chat Screen Loading'}"),
        actions: [
          IconButton(
            onPressed: () {
              Share.share(
                "${routesArguments['chatId']}",
              );
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _chatMessages(),
        _buildMessageField(
          controller: _messageController,
          onSend: sendMessage,
        ),
      ],
    );
  }

  Widget _chatMessages() {
    return Expanded(
      child: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            ..._store.chatMessages.map((chatMessage) {
              return _buildMessageElement(
                isOwner: chatMessage.senderId ==
                    (LocalData().userModel?.userId ?? ""),
                model: chatMessage,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageElement({
    required ChatValModel model,
    bool isOwner = true,
  }) {
    return Align(
      alignment: isOwner ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: screenWidth * 0.6,
        alignment: isOwner ? Alignment.centerRight : Alignment.centerLeft,
        margin: EdgeInsets.only(
          top: screenHeight * 0.015,
          bottom: screenHeight * 0.015,
          left: screenWidth * 0.025,
          right: screenWidth * 0.025,
        ),
        padding: EdgeInsets.only(
          top: screenHeight * 0.01,
          bottom: screenHeight * 0.01,
          left: screenWidth * 0.025,
          right: screenWidth * 0.025,
        ),
        decoration: BoxDecoration(
          color: isOwner ? Colors.blue : Colors.green.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
        child: LimitedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                "${model.message}",
                textAlign: isOwner ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Text(
                "${model.senderName}",
                textAlign: isOwner ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.005,
              ),
              Text(
                DateFormat.yMd().add_jm().format(
                    DateTime.tryParse(model.timeStamp.toString()) ??
                        DateTime.now()),
                textAlign: isOwner ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageField({
    TextEditingController? controller,
    void Function()? onSend,
  }) {
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      width: screenWidth,
      padding: EdgeInsets.only(
        top: screenHeight * 0.01,
        bottom: screenHeight * 0.01,
        left: screenWidth * 0.05,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: screenWidth * 0.75,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: onSend,
            child: IconButton(
              onPressed: onSend,
              iconSize: 35,
              color: Colors.white,
              icon: Transform.rotate(
                angle: -pi / 4.5,
                child: Icon(
                  Icons.send,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void toastMessage(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? "")),
    );
  }

  Future<void> _getChatDetails({String chatId = ""}) async {
    setState(() {
      _store.isLoading = true;
    });
    await _store.getChatDetail(chatId: chatId).then((value) {
      setState(() {
        _store.isLoading = false;
      });
      if (_store.errorMessage != null) {
        toastMessage("${_store.errorMessage}");
      }
    });
  }

  Future<void> _getChatMessages() async {
    await _store.getChatMesagesFromLocal();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _listenChatCollection() async {
    final chatCollection = _store.getChatCollection();
    chatCollection.listen((event) async {
      await Future.forEach(event.docs, (change) {
        _compileMessageFromListner(change.data());
      });
      _getChatMessages();
    });
  }

  void sendMessage() {
    _store
        .sendMessage(
      message: ChatValModel(
        chatId: _store.chatId,
        chatValId: Uuid().v1(),
        message: _messageController.text,
        senderId: LocalData().userModel?.userId ?? "",
        senderName: LocalData().userModel?.name ?? "",
        timeStamp: DateTime.now().millisecondsSinceEpoch,
      ),
    )
        .then((value) {
      _messageController.clear();
      _getChatMessages();
    });
  }

  Future<void> _compileMessageFromListner(
      Map<dynamic, dynamic> parseJson) async {
    final msg = ChatValModel.fromJson(parseJson);
    if (msg.senderId != (LocalData().userModel?.userId ?? "") &&
        msg.isRecieved == false) {
      await _store.setMessageToLocal(message: msg);
      await _store.recievedMessage(chatValId: msg.chatValId);
    } else if (msg.isRecieved == true) {
      await _store.deleteMessage(chatValId: msg.chatValId);
    }
  }
}
