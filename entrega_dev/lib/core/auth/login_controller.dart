import 'package:entrega_dev/core/auth/auth_service.dart';
import 'package:entrega_dev/core/services/presence_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginController {
  final AuthService _authService;

  LoginController(this._authService);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = ValueNotifier<bool>(false);
  final errorMessage = ValueNotifier<String?>(null);

  Future<void> login() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final email = emailController.text;
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        throw AuthException("E-mail e senha são obrigatórios.");
      }

      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final presenceService = PresenceService(FirebaseDatabase.instance, FirebaseAuth.instance);
      await presenceService.iniciaPresencaEntregador();
      Modular.to.navigate('/home');
    } on AuthException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Ocorreu um erro inesperado.';
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isLoading.dispose();
    errorMessage.dispose();
  }
}
