import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega_dev/core/delivery/models/delivery_model.dart';
import 'package:latlong2/latlong.dart';

class DeliveryService {
  final FirebaseFirestore _firestore;
  DeliveryService(this._firestore);

  CollectionReference<Map<String, dynamic>> get _solicitacoesCol =>
      _firestore.collection('solicitacoes');

  CollectionReference<Map<String, dynamic>> get _lojasCol =>
      _firestore.collection('lojas');

  Stream<List<DeliveryModel>> getAvailableDeliveries() {
    return _solicitacoesCol
        .where('status', whereIn: ['pendente', 'em_coleta', 'em_entrega'])
        .orderBy('data_criacao', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<DeliveryModel> entregas = [];

          for (var doc in snapshot.docs) {
            final data = doc.data();

            final String? lojaId = data['loja_id'];

            Map<String, dynamic> lojaData;

            if (lojaId != null && lojaId.isNotEmpty) {
              final lojaDoc = await _lojasCol.doc(lojaId).get();
              if (lojaDoc.exists) {
                lojaData = lojaDoc.data()!;
              } else {
                lojaData = {
                  'lojaNome': 'Loja Parceira',
                  'imagem': '',
                  'localizacaoLoja':
                      data['localizacao'] ?? const GeoPoint(0, 0),
                };
              }
            } else {
              lojaData = {
                'lojaNome': 'Loja Parceira',
                'imagem': '',
                'localizacaoLoja': data['localizacao'] ?? const GeoPoint(0, 0),
              };
            }

            entregas.add(
              _mapToModel(
                doc.id,
                data,
                lojaId ?? '',
                lojaData,
              ),
            );
          }

          return entregas;
        });
  }

  Stream<List<DeliveryModel>> getFinishDeliveriesByUser(String uid) {
    return _solicitacoesCol
        .where('status', isEqualTo: 'finalizada')
        .where('entregador_uid', isEqualTo: uid)
        .orderBy('finishedAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<DeliveryModel> list = [];
          for (var doc in snapshot.docs) {
            final data = doc.data();
            final lojaId = data['loja_id'] ?? '';
            if (lojaId.isEmpty) continue;

            final lojaDoc = await _lojasCol.doc(lojaId).get();
            if (!lojaDoc.exists) continue;

            list.add(_mapToModel(doc.id, data, lojaDoc.id, lojaDoc.data()!));
          }
          return list;
        });
  }

  DeliveryModel _mapToModel(
    String docId,
    Map<String, dynamic> solData,
    String lojaId,
    Map<String, dynamic> lojaData,
  ) {
    final GeoPoint geoLoja =
        lojaData['localizacaoLoja'] ?? const GeoPoint(0, 0);
    final GeoPoint geoCliente = solData['localizacao'] ?? const GeoPoint(0, 0);

    final Timestamp? criadoEm = solData['data_criacao'];

    return DeliveryModel(
      id: docId,
      lojaId: lojaId,
      lojaNome: lojaData['lojaNome'] ?? 'Loja Parceira',
      imagem: lojaData['imagem'] ?? '',
      enderecoLoja:
          "Local da Loja (Ver no mapa)",
      localizacaoLoja: LatLng(geoLoja.latitude, geoLoja.longitude),

      localEntregaTexto: solData['endereco_texto'] ?? 'Endereço não informado',
      localizacaoCliente: LatLng(geoCliente.latitude, geoCliente.longitude),
      status: solData['status'] ?? 'pendente',
      acceptedBy: solData['entregador_uid'],
      dataCriacao: criadoEm?.toDate(),

      preco: (solData['preco'] ?? 15.0).toDouble(),
    );
  }

  Future<void> acceptDelivery({
    required String entregaId,
    required String uid,
  }) async {
    final ref = _solicitacoesCol.doc(entregaId);

    final userDoc = await _firestore.collection('users').doc(uid).get();
    final userData = userDoc.data();
    final String entregadorNome = userData?['nome'] ?? 'Entregador';

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) throw Exception('Solicitação não existe mais');

      final data = snap.data()!;
      if (data['status'] != 'pendente') {
        throw Exception('Esta entrega já foi aceita por outro entregador');
      }

      tx.update(ref, {
        'status': 'em_coleta',
        'entregador_uid': uid,
        'entregador_nome': entregadorNome,
        'acceptedAt': FieldValue.serverTimestamp(),
      });
    });

    await _firestore.collection('users').doc(uid).update({
      'status': 'em_coleta',
    });
  }

  Future<void> confirmarColeta({
    required String entregaId,
    required String uid,
  }) async {
    final ref = _solicitacoesCol.doc(entregaId);

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final data = snap.data()!;

      if (data['entregador_uid'] != uid) {
        throw Exception('Permissão negada');
      }
      if (data['status'] != 'em_coleta') {
        throw Exception('Status inválido para coleta');
      }

      tx.update(ref, {
        'status': 'em_entrega',
        'coletadoEm': FieldValue.serverTimestamp(),
      });
    });

    await _firestore.collection('users').doc(uid).update({
      'status': 'em_entrega',
    });
  }

  Future<void> confirmarEntrega({
    required String entregaId,
    required String uid,
  }) async {
    final ref = _solicitacoesCol.doc(entregaId);

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final data = snap.data()!;

      if (data['entregador_uid'] != uid) {
        throw Exception('Permissão negada');
      }
      if (data['status'] != 'em_entrega') {
        throw Exception('Status inválido para finalizar');
      }

      tx.update(ref, {
        'status': 'finalizada',
        'finishedAt': FieldValue.serverTimestamp(),
      });
    });

    await _firestore.collection('users').doc(uid).update({
      'status': 'disponivel',
    });
  }

  Future<void> cancelDelivery({
    required String entregaId,
    required String uid,
  }) async {
    final ref = _solicitacoesCol.doc(entregaId);

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final data = snap.data()!;

      if (data['entregador_uid'] != uid) {
        throw Exception('Permissão negada');
      }
      if (data['status'] == 'finalizada') {
        throw Exception('Não pode cancelar entrega finalizada');
      }

      tx.update(ref, {
        'status': 'pendente',
        'entregador_uid': FieldValue.delete(),
        'entregador_nome': FieldValue.delete(),
        'acceptedAt': FieldValue.delete(),
      });
    });

    await _firestore.collection('users').doc(uid).update({
      'status': 'disponivel',
    });
  }

  Stream<DeliveryModel?> watchById(String id) {
    return _solicitacoesCol.doc(id).snapshots().asyncMap((doc) async {
      if (!doc.exists) return null;
      final data = doc.data()!;
      final lojaId = data['loja_id'];

      if (lojaId == null) return null;

      final lojaDoc = await _lojasCol.doc(lojaId).get();
      if (!lojaDoc.exists) return null;

      return _mapToModel(doc.id, data, lojaDoc.id, lojaDoc.data()!);
    });
  }
}
