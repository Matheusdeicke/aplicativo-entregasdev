import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class DeliveryModel {
  final String id;
  final String lojaNome;
  final String distancia;
  final String localEntrega;
  final String enderecoLoja;
  final String status;
  final double preco;
  final String? imagem;
  final LatLng? localizacao;        
  final LatLng? localizacaoEntrega; 

  DeliveryModel({
    required this.id,
    required this.lojaNome,
    required this.distancia,
    required this.localEntrega,
    required this.status,
    required this.enderecoLoja,
    required this.preco,
    this.imagem,
    this.localizacao,
    this.localizacaoEntrega,
  });

  factory DeliveryModel.fromMap(String id, Map<String, dynamic> data) {
    LatLng? _gp(dynamic v) {
      if (v is GeoPoint) return LatLng(v.latitude, v.longitude);
      return null;
    }

    return DeliveryModel(
      id: id,
      lojaNome: (data['lojaNome'] ?? '') as String,
      distancia: (data['distancia'] ?? '') as String,
      localEntrega: (data['localEntrega'] ?? '') as String,
      status: (data['status'] ?? '') as String,
      enderecoLoja: (data['enderecoLoja'] ?? '') as String,
      preco: (data['preco'] is num) ? (data['preco'] as num).toDouble() : 0.0,
      imagem: data['imagem'] as String?,
      localizacao: _gp(data['localizacao']),
      localizacaoEntrega: _gp(data['localizacaoEntrega']),
    );
  }
}
