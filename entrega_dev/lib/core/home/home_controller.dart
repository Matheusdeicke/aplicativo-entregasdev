import 'package:firebase_auth/firebase_auth.dart';
import 'package:entrega_dev/core/delivery/models/delivery_model.dart';
import 'package:entrega_dev/core/delivery/services/delivery_service.dart';

class HomeController {
  final FirebaseAuth _auth;
  final DeliveryService _deliveryService;

  HomeController(this._auth, this._deliveryService) {
    _init();
    _loadDeliveries();
  }

  late final String welcomeMessage;
  late final Stream<List<DeliveryModel>> entregasStream;

  void _init() {
    final user = _auth.currentUser;
    final username = (user?.email?.split('@').first) ?? 'Usuário';
    welcomeMessage = 'Olá, bem vindo $username!';
  }

  void _loadDeliveries() {
    entregasStream = _deliveryService.getAvailableDeliveries();
  }
}
