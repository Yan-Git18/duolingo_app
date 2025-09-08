import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _validations = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iniciar Sesión"),
        backgroundColor: Color(0xFF1C1E26),
        ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _validations,
          child: ListView(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Correo",
                  border: OutlineInputBorder(),
                ),
                validator: (correo) {
                  if (correo == null || correo.isEmpty){
                    return "";
                  }
                  String correovalido = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                  RegExp regExp = RegExp(correovalido);

                  if (!regExp.hasMatch(correo)) {
                    return "Ingrese un correo válido (ejemplo@gmail.com)";
                  }
                  return null;
                }
              ),
              const SizedBox(height: 15),

              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
                validator: (contrasena) {
                  if (contrasena == null || contrasena.isEmpty){
                    return "";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

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
                    if (_validations.currentState!.validate()) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                  child: 
                    const Text("Iniciar Sesión",
                    style: TextStyle(
                      fontSize: 18, 
                      color: Colors.white),
                    ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
