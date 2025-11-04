import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:entrega_dev/core/delivery/models/delivery_model.dart';
import 'package:entrega_dev/core/delivery/services/delivery_service.dart';

class DeliveryController {
  final DeliveryService _service;
  final FirebaseAuth _auth;

  late final Stream<List<DeliveryModel>> entregasFinalizadasStream;
  late final Stream<double> totalGanhosStream;

  DeliveryController(this._service, this._auth) {
    final uid = _auth.currentUser?.uid ?? '';
    entregasFinalizadasStream = uid.isEmpty
        ? const Stream.empty()
        : _service.getFinishDeliveriesByUser(uid);

    totalGanhosStream = entregasFinalizadasStream.map(
      (list) => list.fold<double>(0.0, (acc, d) => acc + d.preco),
    );
  }
}
