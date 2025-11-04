import 'package:entrega_dev/core/auth/auth_service.dart';
import 'package:entrega_dev/core/auth/login_page.dart';
import 'package:entrega_dev/core/auth/login_controller.dart';
import 'package:entrega_dev/core/core_module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(i) {
    i.add<AuthService>(() => AuthService(i.get<FirebaseAuth>()));
    i.add<LoginController>(() => LoginController(i.get<AuthService>()));
  }

  @override
  void routes(r) => r.child('/', child: (_) => const LoginPage());
}
