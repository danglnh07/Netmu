import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:netmu/core/utils/logger/logger.dart';
import 'package:netmu/features/auth/screens/login_screen.dart';
import 'package:netmu/features/auth/screens/register_screen.dart';
import 'package:netmu/features/home/splash_screen.dart';
import 'package:netmu/features/movies/screens/main_screen.dart';

Future<void> main() async {
  // Load .env
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    NetmuLog.logger.e("Error loading .env file: $e");
    return;
  }

  // Run app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netmu',
      initialRoute: "/",
      routes: {
        "/": (context) => WelcomeScreen(),
        "/auth/register": (context) => RegisterScreen(),
        "/auth/login": (context) => LoginScreen(),
        "/main": (context) => MainScreen(),
      },
    );
  }
}