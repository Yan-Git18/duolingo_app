import 'package:duolingo_app/app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:duolingo_app/app/screens/account/login_screen.dart';
import 'package:duolingo_app/app/screens/account/register_screen.dart';
import 'package:duolingo_app/app/screens/welcome/welcome_screen.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Duolingo Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1E26),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/registrate': (context) => const RegisterScreen(),
        '/iniciar': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}