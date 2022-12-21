import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth;
  String? errorMessage;

  AuthService(this._auth);

  Stream<User?> get authStateChanges => _auth.idTokenChanges();

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> signIn({required String email, required String pass}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass).then(
          (v) => Fluttertoast.showToast(
              msg: 'Has iniciado sesión correctamente.'));
      return true;
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'invalid-email':
          errorMessage = 'El email no está bien formado.';
          break;
        case 'wrong-password':
          errorMessage = 'La contraseña es incorrecta.';
          break;
        case 'user-not-found':
          errorMessage = 'No existe ningún usuario con este email.';
          break;
        case 'user-disabled':
          errorMessage = 'El usuario con este email ha sido bloqueado.';
          break;
        case 'too-many-requests':
          errorMessage = 'Has hecho demasiados intentos.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Iniciar sesión no está habilitado.';
          break;
        default:
          errorMessage = 'Algo inesperado ha ocurrido.';
      }
      Fluttertoast.showToast(msg: errorMessage!);
      return false;
    }
  }

  Future<void> signUp({required String email, required String pwd}) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: pwd)
          .then((value) => Fluttertoast.showToast(
              msg: 'Has iniciado sesión correctamente.'));
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
        case 'account-exists-with-different-credential':
        case 'email-already-in-use':
          errorMessage =
              'El email introducido ya existe. Vuelve a la página de login.';
          break;
        case 'ERROR_INVALID_EMAIL':
        case 'invalid-email':
          errorMessage = 'El email no está bien formado.';
          break;
        case 'ERROR_WRONG_PASSWORD':
        case 'wrong-password':
          errorMessage = 'La contraseña es incorrecta.';
          break;
        case 'ERROR_USER_NOT_FOUND':
        case 'user-not-found':
          errorMessage = 'No existe ningún usuario con este email.';
          break;
        case 'ERROR_USER_DISABLED':
        case 'user-disabled':
          errorMessage = 'El usuario con este email ha sido bloqueado.';
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
        case 'too-many-requests':
          errorMessage = 'Has hecho demasiados intentos.';
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
        case 'operation-not-allowed':
          errorMessage = 'Registrarse no está habilitado.';
          break;
        default:
          errorMessage = 'Algo inesperado ha ocurrido.';
      }
      Fluttertoast.showToast(msg: errorMessage!);
    }
  }
}
