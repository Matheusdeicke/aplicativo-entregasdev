import 'package:entrega_dev/core/core_module.dart';
import 'package:entrega_dev/core/map/map_controller.dart' as ctrl;
import 'package:entrega_dev/core/map/map_page_entrega.dart';
import 'package:entrega_dev/core/delivery/services/delivery_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:entrega_dev/core/map/map_page.dart';

class MapModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];
  
  @override
  void binds(i) {
    i.add<ctrl.MapController>(() => ctrl.MapController(i.get<DeliveryService>()));
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const MapPage());
    r.child('/entrega', child: (_) => const MapPageEntrega());
  }
}
