import 'package:entrega_dev/core/home/home_controller.dart';
import 'package:entrega_dev/core/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    i.add<HomeController>(HomeController.new);
  }
  
  @override
  void routes(r) => r.child('/', child: (_) => const HomePage());
}