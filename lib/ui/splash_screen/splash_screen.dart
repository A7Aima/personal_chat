import 'package:PersonalChat/const/local_data/local_data.dart';
import 'package:PersonalChat/const/routes/routes.dart';
import 'package:PersonalChat/service/user_service/user_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFirstRun = true;
  UserLocalService _userService = UserLocalService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isFirstRun) {
      isFirstRun = false;
    }
    Future.delayed(
      Duration(seconds: 2),
      () {
        final user = _userService.getUserLocal();
        LocalData().userModel = user;
        if (user != null) {
          _homeScreen();
        } else {
          _introScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "loading...",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _introScreen() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.intro_screen,
      (route) => false,
    );
  }

  void _homeScreen() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home_screen,
      (route) => false,
    );
  }
}
