import 'package:duolingo_app/app/services/auth_service.dart';
import 'package:duolingo_app/app/utils/constants.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _validations = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;

  // Función para iniciar sesión con Firebase
  Future<void> _loginUser() async {
  if (!_validations.currentState!.validate()) return;

  setState(() {
    _isLoading = true;
  });

  final authService = AuthService();
  
  final result = await authService.loginUser(
    email: _emailController.text,
    password: _passwordController.text,
  );

  if (mounted) {
    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message), backgroundColor: AppColors.primary),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message), backgroundColor: Colors.red),
      );
    }
  }

  setState(() {
    _isLoading = false;
  });
}

// Actualizar _resetPassword():
Future<void> _resetPassword() async {
  String email = _emailController.text.trim();
  
  if (email.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ingresa tu correo'), backgroundColor: AppColors.orange),
    );
    return;
  }

  final authService = AuthService();
  final result = await authService.resetPassword(email: email);
  
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message),
        backgroundColor: result.success ? AppColors.primary : Colors.red,
      ),
    );
  }
}

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iniciar Sesión"),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _validations,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              
              // Campo correo
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Correo",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                style: const TextStyle(color: AppColors.white),
                validator: (correo) {
                  if (correo == null || correo.isEmpty) {
                    return "Ingrese un correo";
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
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                style: const TextStyle(color: AppColors.white),
                validator: (contrasena) {
                  if (contrasena == null || contrasena.isEmpty) {
                    return "Ingrese una contraseña";
                  }
                  return null;
                },
              ),
              
              // Enlace "¿Olvidaste tu contraseña?"
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _resetPassword,
                  child: const Text(
                    "¿Olvidaste tu contraseña?",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              // Botón Iniciar Sesión
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _isLoading ? null : _loginUser,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Iniciar Sesión",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.white,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Enlace para registrarse
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "¿No tienes cuenta? ",
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: const Text(
                      "Regístrate",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}