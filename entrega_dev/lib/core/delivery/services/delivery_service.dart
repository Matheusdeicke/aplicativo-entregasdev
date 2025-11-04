import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega_dev/core/delivery/models/delivery_model.dart';

class DeliveryService {
  final FirebaseFirestore _firestore;
  DeliveryService(this._firestore);

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('entregasteste');

  Stream<List<DeliveryModel>> getAvailableDeliveries() {
    return _col
        .where('status', whereIn: ['disponivel', 'aceita'])
        .snapshots()
        .map((s) => s.docs
            .map((d) => DeliveryModel.fromMap(d.id, d.data()))
            .toList());
  }

  Stream<List<DeliveryModel>> getFinishDeliveriesByUser(String uid) {
    return _col
        .where('status', isEqualTo: 'finalizada')
        .where('acceptedBy', isEqualTo: uid)
        .snapshots()
        .map((s) => s.docs
            .map((d) => DeliveryModel.fromMap(d.id, d.data()))
            .toList());
  }

  Stream<DeliveryModel?> watchById(String id) {
    return _col.doc(id).snapshots().map(
          (d) => d.exists ? DeliveryModel.fromMap(d.id, d.data()!) : null,
        );
  }

  Future<void> acceptDelivery({required String entregaId, required String uid}) async {
    final ref = _col.doc(entregaId);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) throw Exception('Entrega não encontrada');

      final data = snap.data() as Map<String, dynamic>;
      final status = (data['status'] ?? '') as String;
      final acceptedBy = data['acceptedBy'] as String?;

      if (status != 'disponivel' || acceptedBy != null) {
        throw Exception('Entrega indisponível');
      }

      await tx.update(ref, {
        'status': 'aceita',
        'acceptedBy': uid,
        'acceptedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> cancelDelivery({required String entregaId, required String uid}) async {
    final ref = _col.doc(entregaId);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) return;

      final data = snap.data() as Map<String, dynamic>;
      final acceptedBy = data['acceptedBy'] as String?;
      final status = (data['status'] ?? '') as String;

      if (acceptedBy != uid) throw Exception('Sem permissão para cancelar');
      if (status == 'finalizada') throw Exception('Já finalizada');

      await tx.update(ref, {
        'status': 'disponivel',
        'acceptedBy': FieldValue.delete(),
        'acceptedAt': FieldValue.delete(),
      });
    });
  }

  Future<void> confirmarColeta({required String entregaId, required String uid}) async {
    final ref = _col.doc(entregaId);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) throw Exception('Entrega não encontrada');

      final data = snap.data() as Map<String, dynamic>;
      if (data['acceptedBy'] != uid) throw Exception('Sem permissão');
      if (data['status'] != 'aceita') throw Exception('Estado inválido');

      await tx.update(ref, {'status': 'em_entrega'});
    });
  }

  Future<void> confirmarEntrega({required String entregaId, required String uid}) async {
    final ref = _col.doc(entregaId);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) throw Exception('Entrega não encontrada');

      final data = snap.data() as Map<String, dynamic>;
      if (data['acceptedBy'] != uid) throw Exception('Sem permissão');
      if (data['status'] != 'em_entrega') throw Exception('Estado inválido');

      await tx.update(ref, {
        'status': 'finalizada',
        'finishedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
