import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGuard extends RouteGuard {
  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Modular.to.navigate('/');
      return false;
    }
    return true;
  }
}
