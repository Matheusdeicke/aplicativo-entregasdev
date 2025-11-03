import 'package:flutter_modular/flutter_modular.dart';
import 'package:entrega_dev/core/models/delivery_model.dart';
import 'package:entrega_dev/core/services/delivery_service.dart';

class MapController {
  final DeliveryService _service;

  late final String entregaId;
  late final Stream<DeliveryModel?> entrega$;

  MapController(this._service) {
    final args = Modular.args.data as Map<String, dynamic>? ?? {};
    entregaId = args['entregaId'] as String? ?? '';
    entrega$ = entregaId.isEmpty ? const Stream.empty() : _service.watchById(entregaId);
  }

  Future<void> confirmarColeta() async {
    if (entregaId.isEmpty) return;
    await _service
        .updateStatus(entregaId: entregaId, novoStatus: 'em_coleta');
  }

  Future<void> cancelarCorrida() async {
    if (entregaId.isEmpty) return;
    await _service
        .updateStatus(entregaId: entregaId, novoStatus: 'cancelada');
  }
}
