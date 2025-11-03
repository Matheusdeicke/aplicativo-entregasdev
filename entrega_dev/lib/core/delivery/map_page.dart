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

  static const LatLng _fallbackCenter = LatLng(-29.690077344166916, -52.455172648394694);
  static const double _zoom = 13.8;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<ctrl.MapController>();
  }

  void _center(LatLng c) => _mapController.move(c, _zoom);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map Page')),
      extendBody: true,
      body: StreamBuilder<model.DeliveryModel?>(
        stream: _controller.entrega$,
        builder: (context, snapshot) {
          final entrega = snapshot.data;
          final origem  = entrega?.localizacao;
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

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  initialCenter: _fallbackCenter,
                  initialZoom: _zoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                    subdomains: const ['a','b','c','d'],
                    userAgentPackageName: 'dev.entrega_dev.app',
                  ),
                  if (poly.length == 2)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: poly,
                          color: const Color.fromARGB(255, 119, 118, 118),
                          strokeWidth: 5,
                        ),
                      ],
                    ),
                  MarkerLayer(
                    markers: [
                      if (origem != null)
                        Marker(
                          point: origem, width: 80, height: 80,
                          child: const Icon(Icons.store, color: Colors.red, size: 40),
                        ),
                      if (destino != null)
                        Marker(
                          point: destino, width: 80, height: 80,
                          child: const Icon(Icons.location_on, color: Color.fromARGB(255, 60, 255, 0), size: 40),
                        ),
                    ],
                  ),
                  const RichAttributionWidget(
                    attributions: [TextSourceAttribution('Mapa Teste')],
                  ),
                ],
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
                          backgroundColor: const Color.fromARGB(200, 88, 86, 86),
                          label: 'Cancelar Corrida',
                          icon: Icons.close,
                        ),
                        ButtonsMapWidget(
                          heroTag: 'iniciar_corrida',
                          onPressed: () async {
                            await _controller.confirmarColeta();
                          },
                          backgroundColor: Colors.green.withOpacity(0.9),
                          label: 'Iniciar Corrida',
                          icon: Icons.check,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
