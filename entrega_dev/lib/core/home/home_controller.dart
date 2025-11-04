import 'package:firebase_auth/firebase_auth.dart';
import 'package:entrega_dev/core/models/delivery_model.dart';
import 'package:entrega_dev/core/services/delivery_service.dart';

class HomeController {
  final FirebaseAuth _auth;
  final DeliveryService _deliveryService;

  late final String welcomeMessage;
  late final Stream<List<DeliveryModel>> entregasStream;

  ////////////// FAZER NO DELIVERY CONTROLLER //////////////
  late final Stream<List<DeliveryModel>> entregasFinalizadasStream;
  //////////////////////////////////////////////////////////

  HomeController(this._auth, this._deliveryService) {
    _init();
  }

  void _init() {
    final user = _auth.currentUser;
    final username = (user?.email?.split('@').first) ?? 'Usuário';
    welcomeMessage = 'Olá, bem vindo $username!';

    entregasStream = _deliveryService.getAvailableDeliveries();
    ////// ISSO NAO DEVE SER AQUI, DEVE SER EM UM DELIVERY_CONTROLLER //////
    entregasFinalizadasStream = _deliveryService.getFinishDeliveries();
    ///////////////////////////////////////////////////////////////////////
  }
}
