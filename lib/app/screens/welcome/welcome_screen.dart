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
            
            const SizedBox(height: 150),
            Image.asset(
              'images/duo.png',
              height: 150,
            ),
            const SizedBox(height: 20),
            
            const Text(
              "duolingo",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF58CC02),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "La forma divertida, efectiva y\n gratis de aprender idiomas!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),

            const SizedBox(height: 150),

            // Botón de registrarse
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                minimumSize: const Size(330, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/registrate');
              },
              child: const Text(
                "REGÍSTRATE",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            const SizedBox(height: 15),

            // Botón de iniciar sesión
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF58CC02), width: 2),
                minimumSize: const Size(330, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/iniciar');
              },
              child: const Text(
                "INICIAR SESIÓN",
                style: TextStyle(fontSize: 18, color: Color(0xFF58CC02)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}