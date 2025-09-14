import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/home/home_screen.dart';

/// Wrapper que maneja automáticamente la navegación basada en el estado de autenticación
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Mostrar loading mientras se verifica el estado
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF1C1E26),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo de Duolingo
                  Icon(
                    Icons.school,
                    size: 80,
                    color: Color(0xFF58CC02),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "duolingo",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF58CC02),
                    ),
                  ),
                  SizedBox(height: 30),
                  CircularProgressIndicator(
                    color: Color(0xFF58CC02),
                  ),
                ],
              ),
            ),
          );
        }

        // Si hay error en la conexión
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFF1C1E26),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Error de conexión",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "No se pudo conectar con Firebase",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // Reintentar navegando a WelcomeScreen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF58CC02),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    child: const Text(
                      "Reintentar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Decidir qué pantalla mostrar basado en el estado de autenticación
        final User? user = snapshot.data;

        if (user != null) {
          // Usuario autenticado -> Ir al Home
          return const HomeScreen();
        } else {
          // Usuario NO autenticado -> Ir a Welcome
          return const WelcomeScreen();
        }
      },
    );
  }
}

/// Versión alternativa con verificación adicional de datos de usuario
class AuthWrapperWithUserData extends StatelessWidget {
  const AuthWrapperWithUserData({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        }

        // Error state
        if (snapshot.hasError) {
          return _buildErrorScreen();
        }

        final User? user = snapshot.data;

        if (user != null) {
          // Usuario autenticado, verificar si tiene datos completos
          return FutureBuilder<Map<String, dynamic>?>(
            future: authService.getUserData(),
            builder: (context, userDataSnapshot) {
              if (userDataSnapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingScreen();
              }

              if (userDataSnapshot.hasData && userDataSnapshot.data != null) {
                // Datos completos -> Home
                return const HomeScreen();
              } else {
                // Usuario sin datos completos -> Logout y mostrar Welcome
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await authService.signOut();
                });
                return const WelcomeScreen();
              }
            },
          );
        } else {
          // No hay usuario -> Welcome
          return const WelcomeScreen();
        }
      },
    );
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      backgroundColor: Color(0xFF1C1E26),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: 80,
              color: Color(0xFF58CC02),
            ),
            SizedBox(height: 20),
            Text(
              "duolingo",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF58CC02),
              ),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(
              color: Color(0xFF58CC02),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1E26),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              "Error de conexión",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "No se pudo conectar con Firebase",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Podríamos implementar un retry mechanism aquí
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text(
                "Reintentar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}