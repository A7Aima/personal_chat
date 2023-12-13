import 'package:PersonalChat/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:PersonalChat/const/routes/routes.dart';
import 'package:PersonalChat/ui/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  runApp(PersonalChat());
}

class PersonalChat extends StatelessWidget {
  PersonalChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      onGenerateRoute: (settings) => Routes.animateRoutes(settings),
    );
  }
}
