import 'package:PersonalChat/const/routes/routes.dart';
import 'package:PersonalChat/store/home_store/home_store.dart';
import 'package:PersonalChat/utility/loading_widget/loading_widget.dart';
import 'package:PersonalChat/utility/mixin/base_mixin/base_mixin.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends BasePageWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen> {
  HomeStore _store = HomeStore();

  @override
  void initializeWithContext(BuildContext context) {
    super.initializeWithContext(context);
    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
      loading: _store.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
          actions: [
            IconButton(
              onPressed: () {
                _store.userService.deleteUserLocal().then((value) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.intro_screen,
                    (route) => false,
                  );
                });
              },
              icon: Icon(Icons.logout_sharp),
            ),
            IconButton(
              onPressed: () {
                _getUserDetails();
              },
              icon: Icon(Icons.refresh_outlined),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: "Add Chat Room",
              onPressed: () {
                _showAddChatRoom();
              },
              child: Icon(
                Icons.add,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            FloatingActionButton(
              heroTag: "Join Chat Room",
              onPressed: () {
                _showJoinChatRoom();
              },
              child: Icon(
                Icons.edit,
              ),
            ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            ..._store.chatList.map((chatVal) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    minVerticalPadding: 0,
                    dense: true,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.chat_screen,
                        arguments: {
                          "chatId": chatVal.chatId,
                        },
                      );
                    },
                    title: Text(
                      "${chatVal.chatName}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "Chat ID: ${chatVal.chatId}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Share.share(
                          "${chatVal.chatId}",
                        );
                      },
                      icon: Icon(Icons.share),
                    ),
                  ),
                  Divider(),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showAddChatRoom() {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: Container(
            margin: EdgeInsets.only(
              top: screenHeight * 0.015,
              bottom: screenHeight * 0.015,
              left: screenWidth * 0.025,
              right: screenWidth * 0.025,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(
                    top: screenHeight * 0.015,
                    bottom: screenHeight * 0.015,
                  ),
                  child: Text(
                    "Create The Chat",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildTextField(
                  label: "Chat Name",
                  hint: "Enter Your Chat Title",
                  onChanged: (value) {
                    _store.chatName = value;
                  },
                ),
                _buildSubmitButton(
                  onPressed: () async {
                    if (_store.chatName.isEmpty) {
                      toastMessage("Field is Empty");
                      return null;
                    }
                    if (_store.chatList.any((element) =>
                        _store.chatName.trim() == element.chatName)) {
                      toastMessage("This name is already available in list");
                      return null;
                    }
                    _store.isLoading = true;
                    await _store.createChatRoom().then((value) {
                      _store.isLoading = false;
                      Navigator.pop(context);
                      _getUserDetails();
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showJoinChatRoom() {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: Container(
            margin: EdgeInsets.only(
              top: screenHeight * 0.015,
              bottom: screenHeight * 0.015,
              left: screenWidth * 0.025,
              right: screenWidth * 0.025,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(
                    top: screenHeight * 0.015,
                    bottom: screenHeight * 0.015,
                  ),
                  child: Text(
                    "Join The Chat",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildTextField(
                  label: "Chat ID",
                  hint: "Enter Your Chat ID",
                  onChanged: (value) {
                    _store.joinId = value;
                  },
                ),
                _buildSubmitButton(
                  onPressed: () async {
                    if (_store.joinId.isEmpty) {
                      toastMessage("Field is Empty");
                      return null;
                    }
                    await _store.joinChatRoom().then((value) {
                      if (_store.errorMessage != null) {
                        toastMessage("${_store.errorMessage}");
                      }
                      Navigator.pop(context);
                      _getUserDetails();
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    String label = "",
    String hint = "",
    TextEditingController? controller,
    void Function(String)? onChanged,
  }) {
    return Container(
      width: screenWidth * 0.9,
      margin: EdgeInsets.only(
        bottom: screenHeight * 0.05,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          label: Text("$label"),
          hintText: "$hint",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildSubmitButton({
    String label = "Submit",
    required void Function()? onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        "$label",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
        fixedSize: Size(screenWidth * 0.45, screenHeight * 0.055),
      ),
    );
  }

  void toastMessage(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? "")),
    );
  }

  void _getUserDetails() {
    _store.isLoading = true;
    _store.getUserDetails().then((value) {
      setState(() {
        _store.isLoading = false;
      });
      if (_store.errorMessage != null) {
        toastMessage("${_store.errorMessage}");
      }
    });
  }
}
