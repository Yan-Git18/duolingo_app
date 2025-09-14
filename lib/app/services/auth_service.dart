import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream del usuario actual
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Usuario actual
  User? get currentUser => _auth.currentUser;

  // Verificar si hay usuario logueado
  bool get isLoggedIn => currentUser != null;

  /// Registrar nuevo usuario
  Future<AuthResult> registerUser({
    required String nombre,
    required String apellidos,
    required int edad,
    required String email,
    required String password,
  }) async {
    try {
      // 1. Crear usuario en Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // 2. Guardar datos adicionales en Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'nombre': nombre.trim(),
        'apellidos': apellidos.trim(),
        'edad': edad,
        'email': email.trim(),
        'fechaRegistro': FieldValue.serverTimestamp(),
        'nivel': 1,
        'puntos': 0,
        'racha': 0,
        'leccionesCompletadas': [],
        'unidadActual': 1,
      });

      // 3. Actualizar displayName
      await userCredential.user!.updateDisplayName('$nombre $apellidos');

      return AuthResult.success(
        user: userCredential.user!,
        message: '¡Registro exitoso! Bienvenido a Duolingo',
      );
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getAuthErrorMessage(e.code));
    } catch (e) {
      return AuthResult.error('Error inesperado: $e');
    }
  }

  /// Iniciar sesión
  Future<AuthResult> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      String userName = userCredential.user?.displayName ?? 'Usuario';
      
      return AuthResult.success(
        user: userCredential.user!,
        message: '¡Bienvenido de nuevo, $userName!',
      );
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getAuthErrorMessage(e.code));
    } catch (e) {
      return AuthResult.error('Error inesperado: $e');
    }
  }

  /// Cerrar sesión
  Future<AuthResult> signOut() async {
    try {
      await _auth.signOut();
      return AuthResult.success(message: 'Sesión cerrada correctamente');
    } catch (e) {
      return AuthResult.error('Error al cerrar sesión: $e');
    }
  }

  /// Restablecer contraseña
  Future<AuthResult> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return AuthResult.success(
        message: 'Se ha enviado un enlace de recuperación a tu correo',
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.code == 'user-not-found'
          ? 'No existe una cuenta con este correo'
          : 'Error al enviar el correo de recuperación';
      return AuthResult.error(errorMessage);
    } catch (e) {
      return AuthResult.error('Error inesperado: $e');
    }
  }

  /// Obtener datos del usuario desde Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      if (currentUser == null) return null;
      
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print('Error al obtener datos del usuario: $e');
      return null;
    }
  }

  /// Actualizar datos del usuario
  Future<bool> updateUserData(Map<String, dynamic> data) async {
    try {
      if (currentUser == null) return false;
      
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .update(data);
      
      return true;
    } catch (e) {
      print('Error al actualizar datos del usuario: $e');
      return false;
    }
  }

  /// Eliminar cuenta de usuario
  Future<AuthResult> deleteAccount() async {
    try {
      if (currentUser == null) {
        return AuthResult.error('No hay usuario autenticado');
      }

      // Eliminar datos de Firestore
      await _firestore.collection('users').doc(currentUser!.uid).delete();
      
      // Eliminar cuenta de Authentication
      await currentUser!.delete();
      
      return AuthResult.success(message: 'Cuenta eliminada correctamente');
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getAuthErrorMessage(e.code));
    } catch (e) {
      return AuthResult.error('Error al eliminar cuenta: $e');
    }
  }

  /// Verificar si el email está verificado
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  /// Enviar verificación de email
  Future<AuthResult> sendEmailVerification() async {
    try {
      if (currentUser == null) {
        return AuthResult.error('No hay usuario autenticado');
      }
      
      await currentUser!.sendEmailVerification();
      return AuthResult.success(
        message: 'Correo de verificación enviado',
      );
    } catch (e) {
      return AuthResult.error('Error al enviar verificación: $e');
    }
  }

  /// Convertir códigos de error de Firebase a mensajes legibles
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'La contraseña es muy débil';
      case 'email-already-in-use':
        return 'Este correo ya está registrado';
      case 'invalid-email':
        return 'El correo no es válido';
      case 'user-not-found':
        return 'No existe una cuenta con este correo';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      case 'requires-recent-login':
        return 'Necesitas iniciar sesión recientemente para esta acción';
      default:
        return 'Error de autenticación: $code';
    }
  }
}

/// Clase para manejar resultados de operaciones de autenticación
class AuthResult {
  final bool success;
  final String message;
  final User? user;

  AuthResult.success({this.user, required this.message}) : success = true;
  AuthResult.error(this.message) : success = false, user = null;
}