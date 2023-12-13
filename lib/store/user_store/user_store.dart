import 'package:PersonalChat/const/local_data/local_data.dart';
import 'package:PersonalChat/model/user_model/user_model.dart';
import 'package:PersonalChat/service/user_service/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserStore {
  UserService _userService = UserService();

  String name = "";

  String email = "";

  String password = "";

  String comfirmPassword = '';

  String? errorMessage;

  bool isLoading = false;

  UserModel? userModel;

  String? validateSignup() {
    if (name.isEmpty) {
      return "Name provided is empty";
    }
    if (email.isEmpty) {
      return "Email provided is empty";
    }
    if (password.isEmpty) {
      return "Password provided is empty";
    }
    if (comfirmPassword.isEmpty) {
      return "Please put the same password as above";
    }
    if (comfirmPassword != password) {
      return "Passwords are not matching";
    }
    return null;
  }

  String? validateLogin() {
    if (email.isEmpty) {
      return "Email provided is empty";
    }
    if (password.isEmpty) {
      return "Password provided is empty";
    }
    return null;
  }

  Future<void> createUser() async {
    errorMessage = null;
    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? userResult = result.user;
      if (userResult != null) {
        userModel = UserModel(
          userId: userResult.uid,
          email: userResult.email,
          name: name,
          chatListId: [],
        );
        LocalData().userModel = userModel;
        final userMap = userModel?.toMap() ?? {};
        await _userService.dbStore.saveUser(userModel?.toMap() ?? {});
        await _userService.createUser(userMap);
        errorMessage = null;
      } else {
        errorMessage = "User Already Used";
      }
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Future<void> getUser() async {
    errorMessage = null;
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = result.user?.uid ?? "";
      final userMap = await _userService.getUser(userId);
      if (userMap.isNotEmpty) {
        LocalData().userModel = UserModel.fromJson(userMap);
        userModel = LocalData().userModel;
        final resultUser = userModel?.toMap() ?? {};
        await _userService.dbStore.saveUser(resultUser);
        errorMessage = null;
      } else {
        errorMessage = "Unable To Fetch Data";
      }
    } catch (e) {
      errorMessage = e.toString();
    }
  }
}
