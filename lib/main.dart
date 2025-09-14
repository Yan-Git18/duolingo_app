import 'package:duolingo_app/app/screens/home/home_screen.dart';
import 'package:duolingo_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:duolingo_app/app/screens/auth/login_screen.dart';
import 'package:duolingo_app/app/screens/auth/register_screen.dart';
import 'package:duolingo_app/app/screens/auth/welcome_screen.dart';
import 'package:duolingo_app/app/widgets/auth_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      
      // Usar AuthWrapper como pantalla inicial
      home: const AuthWrapper(),
      
      // Mantener las rutas para navegación manual cuando sea necesario
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}