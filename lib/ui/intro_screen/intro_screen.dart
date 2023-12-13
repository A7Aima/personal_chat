import 'package:PersonalChat/const/routes/routes.dart';
import 'package:PersonalChat/utility/mixin/base_mixin/base_mixin.dart';
import 'package:flutter/material.dart';

class IntroScreen extends BasePageWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends BaseState<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeadingText(),
            _buildBodyText(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadingText() {
    return Container(
      margin: EdgeInsets.only(
        top: screenHeight * 0.1,
      ),
      child: Text(
        "Welcome to\nPersonal Chat",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _buildBodyText() {
    return Container(
      margin: EdgeInsets.only(
        top: screenHeight * 0.1,
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
      ),
      child: Text(
        "Where u can personally chat\nwith ur friends and family in an instant",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Container(
      margin: EdgeInsets.only(
        top: screenHeight * 0.1,
      ),
      child: Column(
        children: [
          Text(
            "Please Proceed with",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: screenHeight * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.login_screen,
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    fixedSize: Size(
                      screenWidth * 0.25,
                      screenHeight * 0.075,
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.signup_screen,
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    fixedSize: Size(
                      screenWidth * 0.25,
                      screenHeight * 0.075,
                    ),
                  ),
                  child: Text(
                    "Signup",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
