import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:netmu/core/utils/api/token_storage.dart';
import 'package:netmu/core/utils/logger/logger.dart';
import 'package:netmu/features/auth/screens/login_screen.dart';
import 'package:netmu/features/auth/screens/register_screen.dart';
import 'package:netmu/features/home/splash_screen.dart';
import 'package:netmu/features/home/main_screen.dart';

Future<void> main() async {
  // Load .env
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    NetmuLog.logger.e("Error loading .env file: $e");
    return;
  }

  // Get token storage
  final storage = SecureTokenStorage();

  // Check if user is logged in
  var isLoggedIn = await storage.getAccessToken() != null;
  NetmuLog.logger.i("Is user logged in: $isLoggedIn");

  // Run app
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netmu',
      initialRoute: "/",
      routes: {
        "/": (context) => isLoggedIn ? HomePage() : WelcomeScreen() ,
        "/auth/register": (context) => RegisterScreen(),
        "/auth/login": (context) => LoginScreen(),
        "/main": (context) => HomePage(),
      },
    );
  }
}
