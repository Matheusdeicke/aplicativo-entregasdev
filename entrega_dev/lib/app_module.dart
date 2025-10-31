import 'package:flutter_modular/flutter_modular.dart';
import 'package:entrega_dev/modules/auth/login_module.dart';
import 'package:entrega_dev/modules/home/home_module.dart';
import 'package:entrega_dev/modules/delivery/delivery_module.dart';

class AppModule extends Module {
  @override
  void routes(r) {
    r.module('/', module: LoginModule());
    r.module('/home', module: HomeModule());
    r.module('/delivery', module: DeliveryModule());
    r.module('/delivery/finish', module: DeliveryModule());
  }
}
