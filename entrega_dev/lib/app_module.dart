import 'package:flutter_modular/flutter_modular.dart';
import 'package:entrega_dev/core/auth/login_page.dart';
import 'package:entrega_dev/core/home/home_page.dart';

class AppModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (_) => const LoginPage());
    r.child('/home', child: (_) => const HomePage());
  }
}
