import 'package:entrega_dev/core/auth/login_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (_) => const LoginPage());
  }
}
