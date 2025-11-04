import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega_dev/core/models/delivery_model.dart';

class DeliveryService {
  final FirebaseFirestore _firestore;

  DeliveryService(this._firestore);

  Stream<List<DeliveryModel>> getAvailableDeliveries() {
    return _firestore
        .collection('entregasteste')
        .where('status', whereIn: ['cancelada', 'confirmada'])
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((d) => DeliveryModel.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  Stream<List<DeliveryModel>> getFinishDeliveries() {
    return _firestore
        .collection('entregasteste')
        .where('status', isEqualTo: 'finalizada')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((f) => DeliveryModel.fromMap(f.id, f.data()))
              .toList(),
        );
  }

  Stream<DeliveryModel?> watchById(String id) {
    return _firestore.collection('entregasteste').doc(id).snapshots().map((
      doc,
    ) {
      if (!doc.exists || doc.data() == null) return null;
      return DeliveryModel.fromMap(doc.id, doc.data()!);
    });
  }

  Future<void> updateStatus({
    required String entregaId,
    required String novoStatus,
  }) {
    return _firestore.collection('entregasteste').doc(entregaId).update({
      'status': novoStatus,
      'atualizadoEm': FieldValue.serverTimestamp(),
    });
  }
}
