import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega_dev/core/home/home_controller.dart';
import 'package:entrega_dev/core/home/home_page.dart';
import 'package:entrega_dev/core/services/delivery_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    i.addSingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

    i.addLazySingleton<DeliveryService>(
      () => DeliveryService(i.get<FirebaseFirestore>()),
    );

    i.addLazySingleton<HomeController>(
      () => HomeController(
        i.get<FirebaseAuth>(),
        i.get<DeliveryService>(),
      ),
    );
  }

  @override
  void routes(r) => r.child('/', child: (_) => const HomePage());
}

