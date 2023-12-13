import 'package:PersonalChat/ui/chat_screen/chat_screen.dart';
import 'package:PersonalChat/ui/home_screen/home_screen.dart';
import 'package:PersonalChat/ui/intro_screen/intro_screen.dart';
import 'package:PersonalChat/ui/login_screen/login_screen.dart';
import 'package:PersonalChat/ui/signup_screen/signup_screen.dart';
import 'package:PersonalChat/ui/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  static const String login_screen = "/login_screen";
  static const String signup_screen = "/signup_screen";
  static const String home_screen = "/home_screen";
  static const String chat_screen = "/chat_screen";
  static const String intro_screen = "/intro_screen";

  static Route animateRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case login_screen:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
          settings: routeSettings,
        );
      case signup_screen:
        return MaterialPageRoute(
          builder: (_) => SignupScreen(),
          settings: routeSettings,
        );
      case home_screen:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
          settings: routeSettings,
        );
      case chat_screen:
        return MaterialPageRoute(
          builder: (_) => ChatScreen(),
          settings: routeSettings,
        );
      case intro_screen:
        return MaterialPageRoute(
          builder: (_) => IntroScreen(),
          settings: routeSettings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
          settings: routeSettings,
        );
    }
  }
}
