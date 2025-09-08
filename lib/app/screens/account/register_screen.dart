import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _validations = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Regístrate"),
        backgroundColor: Color(0xFF1C1E26),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(       
            key: _validations, 
            child: ListView(
              children: [
                // Campo nombre
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Nombre",       
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Color(0xffffffff)),
                  validator: (nombres) {
                    if(nombres == null || nombres.isEmpty) {
                      return "";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

              // Campo apellidos
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Apellidos",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Color(0xffffffff)),
                validator: (apellidos) {
                  if (apellidos == null || apellidos.isEmpty) {
                    return "";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Campo edad
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Edad",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Color(0xffffffff)),
                validator: (edad) {
                  if (edad == null || edad.isEmpty) {
                    return "";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Campo correo
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Correo",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Color(0xffffffff)),
                validator: (correo) {
                  if (correo == null || correo.isEmpty) {
                    return "";
                  }
                  String correovalido = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                  RegExp regExp = RegExp(correovalido);

                  if (!regExp.hasMatch(correo)) {
                    return "Ingrese un correo válido (ejemplo@gmail.com)";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Campo contraseña
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Color(0xffffffff)),
                validator: (contrasena) {
                  if (contrasena == null || contrasena.isEmpty) {
                    return "";
                  }
                  return null;
                },
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
                    if (_validations.currentState!.validate()) {
                      Navigator.pushNamed(context, '/');
                    }                    
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
      )
    );
  }
}