import 'dart:math';
import 'package:entrega_dev/widgets/buttons_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:entrega_dev/core/delivery/map_controller.dart' as ctrl;
import 'package:entrega_dev/core/models/delivery_model.dart' as model;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _mapController = MapController();
  late final ctrl.MapController _controller;

  static const LatLng _fallbackCenter =
      LatLng(-29.690077344166916, -52.455172648394694);
  static const double _zoom = 13.8;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<ctrl.MapController>();
  }

  void _center(LatLng c) => _mapController.move(c, _zoom);

  double? _extractKm(String? s) {
    if (s == null) return null;
    final m = RegExp(r'(\d+(?:[.,]\d+)?)').firstMatch(s);
    if (m == null) return null;
    return double.tryParse(m.group(1)!.replaceAll(',', '.'));
  }

  String _estimativaMinutos(String? distanciaRaw) {
    final km = _extractKm(distanciaRaw);
    if (km == null) return '--';
    final mins = (km * 2.5);
    final arred = max(1, mins.round());
    return '$arred minutos';
  }

  Widget _deliveryHeader(model.DeliveryModel e) {
    final distancia = e.distancia;
    final estimativa = _estimativaMinutos(distancia);
    final destinoLinha1 = e.localEntrega ?? e.enderecoLoja ?? '';

    return Container(
      color: const Color(0xFF121212),
      padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: (e.imagem != null && e.imagem!.isNotEmpty)
                ? Image.network(e.imagem!, fit: BoxFit.cover)
                : const Icon(Icons.local_shipping, color: Colors.white70),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.lojaNome,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (distancia != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        distancia,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Local de entrega',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                Text(
                  destinoLinha1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$estimativa até o local',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _bigCenterTitle(String distancia, String estimativa) {
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
            '$estimativa até o local',
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
          final entrega = snapshot.data;
          final origem = entrega?.localizacao;
          final destino = entrega?.localizacaoEntrega;

          final center = (origem != null && destino != null)
              ? LatLng(
                  (origem.latitude + destino.latitude) / 2,
                  (origem.longitude + destino.longitude) / 2,
                )
              : (origem ?? destino ?? _fallbackCenter);

          WidgetsBinding.instance.addPostFrameCallback((_) => _center(center));

          final poly = <LatLng>[
            if (origem != null) origem,
            if (destino != null) destino,
          ];

          final distanciaTxt = entrega?.distancia ?? '--';
          final estimativa = _estimativaMinutos(entrega?.distancia);

          return Column(
            children: [
              if (entrega != null)
                _deliveryHeader(entrega)
              else
                const SizedBox(height: 100),

              Expanded(
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: const MapOptions(
                        initialCenter: _fallbackCenter,
                        initialZoom: _zoom,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                          subdomains: const ['a', 'b', 'c', 'd'],
                          userAgentPackageName: 'dev.entrega_dev.app',
                        ),
                        if (poly.length == 2)
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: poly,
                                color:
                                    const Color.fromARGB(255, 119, 118, 118),
                                strokeWidth: 5,
                              ),
                            ],
                          ),
                        MarkerLayer(
                          markers: [
                            if (origem != null)
                              Marker(
                                point: origem,
                                width: 80,
                                height: 80,
                                child: const Icon(Icons.store,
                                    color: Colors.red, size: 40),
                              ),
                            if (destino != null)
                              Marker(
                                point: destino,
                                width: 80,
                                height: 80,
                                child: const Icon(Icons.location_on,
                                    color: Color.fromARGB(255, 60, 255, 0),
                                    size: 40),
                              ),
                          ],
                        ),
                        const RichAttributionWidget(
                          attributions: [TextSourceAttribution('Mapa Teste')],
                        ),
                      ],
                    ),
                    if (entrega != null)
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: _bigCenterTitle(distanciaTxt, estimativa),
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
                                heroTag: 'cancelar_corrida',
                                onPressed: () async {
                                  await _controller.cancelarCorrida();
                                  Modular.to.navigate('/home');
                                },
                                backgroundColor:
                                    const Color.fromARGB(200, 88, 86, 86),
                                label: 'Cancelar Corrida',
                                icon: Icons.close,
                              ),
                              ButtonsMapWidget(
                                heroTag: 'iniciar_corrida',
                                onPressed: () async {
                                  await _controller.confirmarColeta();
                                },
                                backgroundColor:
                                    Colors.green.withOpacity(0.9),
                                label: 'Confirmar coleta',
                                icon: Icons.check,
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
