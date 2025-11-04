import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega_dev/core/map/map_controller.dart' as ctrl;
import 'package:entrega_dev/core/map/map_page_entrega.dart';
import 'package:entrega_dev/core/services/delivery_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:entrega_dev/core/map/map_page.dart';

class MapModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
    i.addLazySingleton<DeliveryService>(() => DeliveryService(i.get<FirebaseFirestore>()));
    i.add<ctrl.MapController>(() => ctrl.MapController(i.get<DeliveryService>()));
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const MapPage());
    r.child('/entrega', child: (_) => const MapPageEntrega());
  }
}
