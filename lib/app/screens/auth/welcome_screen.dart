import 'package:duolingo_app/app/utils/constants.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [            
            const SizedBox(height: 200),
            AppImages.logo,
            const SizedBox(height: 20),
            
            const Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              AppStrings.welcome,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),

            const SizedBox(height: 250),

            // Botón de registrarse
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(330, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text(
                "REGÍSTRATE",
                style: TextStyle(fontSize: 18, color: AppColors.white),
              ),
            ),

            const SizedBox(height: 15),

            // Botón de iniciar sesión
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 2),
                minimumSize: const Size(330, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                "INICIAR SESIÓN",
                style: TextStyle(fontSize: 18, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}