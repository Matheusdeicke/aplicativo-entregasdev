import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:entrega_dev/core/delivery/models/delivery_model.dart';
import 'package:entrega_dev/core/delivery/services/delivery_service.dart';

class MapController {
  final DeliveryService _service;
  final FirebaseAuth _auth = Modular.get<FirebaseAuth>();

  late final String entregaId;
  late final Stream<DeliveryModel?> entrega$;

  MapController(this._service) {
    final args = Modular.args.data as Map<String, dynamic>? ?? {};
    entregaId = args['entregaId'] as String? ?? '';
    entrega$ = entregaId.isEmpty
        ? const Stream.empty()
        : _service.watchById(entregaId);
  }

  String? get _uid => _auth.currentUser?.uid;
  String get currentEntregaId => entregaId;

  Future<void> aceitarEntrega() async {
    final uid = _uid;
    if (entregaId.isEmpty || uid == null) return;
    await _service.acceptDelivery(entregaId: entregaId, uid: uid);
  }

  Future<void> cancelarCorrida() async {
    final uid = _uid;
    if (entregaId.isEmpty || uid == null) return;
    await _service.cancelDelivery(entregaId: entregaId, uid: uid);
  }

  Future<void> confirmarColeta() async {
    final uid = _uid;
    if (entregaId.isEmpty || uid == null) return;
    await _service.confirmarColeta(entregaId: entregaId, uid: uid);
  }

  Future<void> confirmarEntrega() async {
    final uid = _uid;
    if (entregaId.isEmpty || uid == null) return;
    await _service.confirmarEntrega(entregaId: entregaId, uid: uid);
  }
}
