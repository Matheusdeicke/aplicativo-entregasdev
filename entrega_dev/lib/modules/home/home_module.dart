import 'package:entrega_dev/core/core_module.dart';
import 'package:entrega_dev/core/home/home_controller.dart';
import 'package:entrega_dev/core/home/home_page.dart';
import 'package:entrega_dev/core/delivery/services/delivery_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];
  
  @override
  void binds(i) {
    i.addLazySingleton<HomeController>(() => HomeController(
          i.get<FirebaseAuth>(),
          i.get<DeliveryService>(),
        ));
  }

  @override
  void routes(r) => r.child('/', child: (_) => const HomePage());
}

