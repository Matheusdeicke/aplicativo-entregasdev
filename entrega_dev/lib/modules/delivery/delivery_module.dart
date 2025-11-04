import 'package:entrega_dev/core/core_module.dart';
import 'package:entrega_dev/core/delivery/delivery_controller.dart';
import 'package:entrega_dev/core/delivery/delivery_finish_page.dart';
import 'package:entrega_dev/core/delivery/services/delivery_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DeliveryModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];
  
  @override
  void binds(i) {
    i.addLazySingleton<DeliveryController>(() => DeliveryController(
          i.get<DeliveryService>(),
          i.get<FirebaseAuth>(),
        ));

  }

  @override
  void routes(r) {
    r.child('/finish', child: (_) => const DeliveryFinish());
  }
}
