import 'package:latlong2/latlong.dart';

class DeliveryModel {
  final String id;
  final String lojaId;
  final String lojaNome;
  final String imagem;
  final String enderecoLoja;
  final LatLng localizacaoLoja;
  
  final String localEntregaTexto;
  final LatLng localizacaoCliente;
  
  final double preco;
  final String status;
  final String? acceptedBy;
  final DateTime? dataCriacao;

  DeliveryModel({
    required this.id,
    required this.lojaId,
    required this.lojaNome,
    required this.imagem,
    required this.enderecoLoja,
    required this.localizacaoLoja,
    required this.localEntregaTexto,
    required this.localizacaoCliente,
    required this.preco,
    required this.status,
    this.acceptedBy,
    this.dataCriacao,
  });

  String get localEntrega => localEntregaTexto;
  LatLng get localizacao => localizacaoLoja; 
  LatLng get localizacaoEntrega => localizacaoCliente;

  String get distancia {
    final dist = const Distance().as(LengthUnit.Kilometer, localizacaoLoja, localizacaoCliente);
    return '${dist.toStringAsFixed(1)} km';
  }
}