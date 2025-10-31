import 'package:entrega_dev/core/delivery/delivery_finish.dart';
import 'package:entrega_dev/core/delivery/map_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DeliveryModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (_) => const MapPage());
    r.child('/finish', child: (_) => const DeliveryFinish());
  }
}