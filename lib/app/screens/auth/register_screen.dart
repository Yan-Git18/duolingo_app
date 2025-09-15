import 'package:duolingo_app/app/services/auth_service.dart';
import 'package:duolingo_app/app/utils/constants.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _validations = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  // Función para registrar usuario con Firebase
  Future<void> _registerUser() async {
    if (!_validations.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final authService = AuthService();

    final result = await authService.registerUser(
      nombre: _nameController.text,
      apellidos: _lastNameController.text,
      edad: int.parse(_ageController.text),
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (mounted) {
      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: AppColors.primary,
          ),
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

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Regístrate"),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _validations,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              // Campo nombre
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nombre",
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: AppColors.white),
                validator: (nombres) {
                  if (nombres == null || nombres.isEmpty) {
                    return "Ingrese su nombre";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Campo apellidos
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: "Apellidos",
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: AppColors.white),
                validator: (apellidos) {
                  if (apellidos == null || apellidos.isEmpty) {
                    return "Ingrese sus apellidos";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Campo edad
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Edad",
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: AppColors.white),
                validator: (edad) {
                  if (edad == null || edad.isEmpty) {
                    return "Ingrese su edad";
                  }
                  int? edadNum = int.tryParse(edad);
                  if (edadNum == null || edadNum < 5 || edadNum > 120) {
                    return "Ingrese una edad válida";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Campo correo
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Correo",
                  border: OutlineInputBorder(),
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
                  helperText: "Mínimo 6 caracteres",
                ),
                style: const TextStyle(color: AppColors.white),
                validator: (contrasena) {
                  if (contrasena == null || contrasena.isEmpty) {
                    return "Ingrese una contraseña";
                  }
                  if (contrasena.length < 6) {
                    return "La contraseña debe tener al menos 6 caracteres";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Campo confirmar contraseña
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirmar Contraseña",
                  border: OutlineInputBorder(),
                  helperText: "Debe coincidir con la contraseña anterior",
                ),
                style: const TextStyle(color: AppColors.white),
                validator: (confirmarContrasena) {
                  if (confirmarContrasena == null ||
                      confirmarContrasena.isEmpty) {
                    return "Confirme su contraseña";
                  }
                  if (confirmarContrasena != _passwordController.text) {
                    return "Las contraseñas no coinciden";
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
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _isLoading ? null : _registerUser,
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
                          "Registrarse",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
