import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Regístrate"),
        backgroundColor: Color(0xFF1C1E26),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // Campo nombre
            const TextField(
              decoration: InputDecoration(
                labelText: "Nombre",       
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Color(0xffffffff)),
            ),
            const SizedBox(height: 15),

            // Campo apellidos
            const TextField(
              decoration: InputDecoration(
                labelText: "Apellidos",
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Color(0xffffffff)),
            ),
            const SizedBox(height: 15),

            // Campo edad
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Edad",
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Color(0xffffffff)),
            ),
            const SizedBox(height: 15),

            // Campo correo
            const TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Correo",
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Color(0xffffffff)),
            ),
            const SizedBox(height: 15),

            // Campo contraseña
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Color(0xffffffff)),
            ),
            const SizedBox(height: 30),

            // Botón Registrarse
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58CC02),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // 👉 Solo navega a welcome
                  Navigator.pushNamed(context, '/');
                },
                child: const Text(
                  "Registrarse",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}