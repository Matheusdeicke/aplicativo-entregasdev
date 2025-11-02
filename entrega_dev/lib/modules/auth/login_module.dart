
import 'package:entrega_dev/core/auth/auth_service.dart';
import 'package:entrega_dev/core/auth/login_page.dart';
import 'package:entrega_dev/core/auth/login_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    i.add<AuthService>(AuthService.new);
    i.add<LoginController>(LoginController.new);
  }
  
  @override
  void routes(r) => r.child('/', child: (_) => const LoginPage());
}
