import 'package:entrega_dev/core/core_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:entrega_dev/modules/auth/login_module.dart';
import 'package:entrega_dev/modules/home/home_module.dart';
import 'package:entrega_dev/modules/delivery/delivery_module.dart';
import 'package:entrega_dev/modules/map/map_module.dart';
import 'package:entrega_dev/core/auth/auth_guard.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.module('/', module: LoginModule());

    r.module('/home', module: HomeModule(), guards: [AuthGuard()]);
    r.module('/delivery', module: DeliveryModule(), guards: [AuthGuard()]);
    r.module('/map', module: MapModule(), guards: [AuthGuard()]);
  }
}
