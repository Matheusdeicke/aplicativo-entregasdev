
import 'package:entrega_dev/core/delivery/map_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void routes(r) {
    r.child('/mapa', child: (_) => const MapPage());
  }
}