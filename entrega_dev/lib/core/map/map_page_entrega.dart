import 'package:entrega_dev/widgets/buttons_map.dart';
import 'package:entrega_dev/widgets/delivery_header.dart';
import 'package:entrega_dev/widgets/map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:latlong2/latlong.dart';
import 'package:entrega_dev/core/map/map_controller.dart' as ctrl;
import 'package:entrega_dev/core/delivery/models/delivery_model.dart' as model;

class MapPageEntrega extends StatefulWidget {
  const MapPageEntrega({super.key});

  @override
  State<MapPageEntrega> createState() => _MapPageEntregaState();
}

class _MapPageEntregaState extends State<MapPageEntrega> {
  late final ctrl.MapController _controller;

  static const LatLng _fallbackCenter =
      LatLng(-29.690077344166916, -52.455172648394694);
  static const double _zoom = 13.8;

  final _distancia = const Distance();
  static const _velocidadeMediaKmh = 24.0;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<ctrl.MapController>();
  }

  double? _kmBetween(LatLng? a, LatLng? b) {
    if (a == null || b == null) return null;
    return _distancia.as(LengthUnit.Kilometer, a, b);
  }

  int? _etaMinutes(double? km) {
    if (km == null) return null;
    final minutes = (km / _velocidadeMediaKmh) * 60.0;
    return minutes.clamp(1, double.infinity).round();
  }

  String _fmtKm(double? km) {
    if (km == null) return '--';
    final decimals = km < 10 ? 2 : 1;
    return '${km.toStringAsFixed(decimals).replaceAll('.', ',')} km';
  }

  String _fmtMin(int? m) => m == null ? '--' : '$m min';

  Widget _centerTitle(String distancia, String estimativa) {
    return IgnorePointer(
      ignoring: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            distancia,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$estimativa até o cliente',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      extendBody: true,
      body: StreamBuilder<model.DeliveryModel?>(
        stream: _controller.entrega$,
        builder: (context, snapshot) {
          // loading enquanto não tiver dados
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final e = snapshot.data;
          if (e == null) {
            return const Center(
              child: Text(
                'Nenhuma entrega selecionada.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final loja = e.localizacao;
          final cliente = e.localizacaoEntrega;

          final center = (loja != null && cliente != null)
              ? LatLng(
                  (loja.latitude + cliente.latitude) / 2,
                  (loja.longitude + cliente.longitude) / 2,
                )
              : (loja ?? cliente ?? _fallbackCenter);

          final poly = <LatLng>[
            if (loja != null) loja,
            if (cliente != null) cliente,
          ];

          final km = _kmBetween(loja, cliente);
          final etaMin = _etaMinutes(km);
          final distanciaTxt = _fmtKm(km);
          final etaTxt = _fmtMin(etaMin);

          return Column(
            children: [
              DeliveryHeader(
                imageUrl: e.imagem,
                title: e.lojaNome,
                subtitle: 'Entrega para',
                addressLine: e.localEntrega,
                distanceText: distanciaTxt,
                etaText: '$etaTxt até o cliente',
              ),

              Expanded(
                child: Stack(
                  children: [
                    MapView(
                      initialCenter: _fallbackCenter,
                      initialZoom: _zoom,
                      centerOnBuild: center,
                      polyline: poly,      
                      origemMarker: cliente,     
                      destinoMarker: loja,  
                    ),

                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _centerTitle(distanciaTxt, etaTxt),
                      ),
                    ),

                    SafeArea(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ButtonsMapWidget(
                                heroTag: 'cancelar_entrega',
                                onPressed: () async {
                                  await _controller.cancelarCorrida();
                                  Modular.to.navigate('/home');
                                },
                                backgroundColor:
                                    const Color.fromARGB(200, 88, 86, 86),
                                label: 'Cancelar',
                                icon: Icons.close,
                              ),
                              ButtonsMapWidget(
                                heroTag: 'confirmar_entrega',
                                onPressed: () async {
                                  await _controller.confirmarEntrega();
                                  Modular.to.navigate('/home');
                                },
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 0, 0),
                                label: 'Confirmar entrega',
                                icon: Icons.check_circle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
