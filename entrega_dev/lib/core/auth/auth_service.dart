import 'package:entrega_dev/core/auth/location_tracker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = _firebaseAuth.currentUser!.uid;
      LocationTracker.start(uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        throw AuthException('E-mail ou senha inválidos.');
      } else if (e.code == 'invalid-email') {
        throw AuthException('O formato do e-mail é inválido.');
      } else if (e.code == 'too-many-requests') {
        throw AuthException('Muitas tentativas. Tente novamente mais tarde.');
      } else {
        throw AuthException('Ocorreu um erro. Tente novamente.');
      }
    } catch (e) {
      throw AuthException('Ocorreu um erro inesperado.');
    }
  }

  Future<void> signOut() async {
    LocationTracker.stop();
    await _firebaseAuth.signOut();
  }
}
