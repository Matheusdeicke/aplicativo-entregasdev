import 'dart:async';
import 'package:entrega_dev/widgets/buttons_map.dart';
import 'package:entrega_dev/widgets/delivery_header.dart';
import 'package:entrega_dev/widgets/map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:entrega_dev/core/map/map_controller.dart' as ctrl;
import 'package:entrega_dev/core/delivery/models/delivery_model.dart' as model;

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final ctrl.MapController _controller;
  // bool _isRunning = false;

  static const LatLng _fallbackCenter = LatLng(
    -29.690077344166916,
    -52.455172648394694,
  );
  static const double _zoom = 13.8;

  // localização do entregador
  StreamSubscription<Position>? _posSub;
  LatLng? _entregador;
  String? _locErrorMessage;

  // distância/ETA
  final _dist = const Distance();
  static const _avgSpeedKmh = 24.0;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<ctrl.MapController>();
    _initLocationStream();
  }

  @override
  void dispose() {
    _posSub?.cancel();
    super.dispose();
  }

  Future<void> _initLocationStream() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // verificação
      if (mounted) {
        setState(
          () => _locErrorMessage = 'Serviço de localização desativado. Ative o GPS.',
        );
      }
      return;
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied) {
      // verificação
      if (mounted) {
        setState(() => _locErrorMessage = 'Permissão de localização negada.');
      }
      return;
    }
    if (perm == LocationPermission.deniedForever) {
      // verificação
      if (mounted) {
        setState(
          () => _locErrorMessage =
              'Permissão negada permanentemente.',
        );
      }
      return;
    }

    try {
      final p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      // verificação
      if (mounted) {
        setState(() {
          _entregador = LatLng(p.latitude, p.longitude);
          _locErrorMessage = null;
        });
      }
    } catch (_) {
      // verificação
      if (mounted) {
        setState(
          () => _locErrorMessage = 'Não foi possível obter a localização inicial.',
        );
      }
    }

    _posSub = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 5, // atualiza a cada 5metros
          ),
        ).listen((pos) {
          if (mounted) {
            setState(() {
              _entregador = LatLng(pos.latitude, pos.longitude);
            });
          }
        });
  }

  // distância/ETA em tempo real
  double? _kmBetween(LatLng? a, LatLng? b) {
    if (a == null || b == null) return null;
    return _dist.as(LengthUnit.Kilometer, a, b);
  }

  int? _etaMinutes(double? km) {
    if (km == null) return null;
    final minutes = (km / _avgSpeedKmh) * 60.0;
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
          final e = snapshot.data;

          final loja = e?.localizacao;

          final origem = _entregador;

          final center = (origem != null && loja != null)
              ? LatLng(
                  (origem.latitude + loja.latitude) / 2,
                  (origem.longitude + loja.longitude) / 2,
                )
              : (origem ?? loja ?? _fallbackCenter);

          final poly = <LatLng>[
            if (origem != null) origem,
            if (loja != null) loja,
          ];

          final km = _kmBetween(origem, loja);
          final etaMin = _etaMinutes(km);
          final distanciaTxt = _fmtKm(km);
          final etaTxt = _fmtMin(etaMin);

          return Column(
            children: [
              if (e != null)
                DeliveryHeader(
                  imageUrl: e.imagem,
                  title: e.lojaNome,
                  subtitle: 'Local de retirada',
                  addressLine: e.enderecoLoja,
                  distanceText: distanciaTxt,
                  etaText: '$etaTxt até o local',
                )
              else
                const SizedBox(height: 100),

              if (_locErrorMessage != null)
                Container(
                  width: double.infinity,
                  color: const Color(0xFF2A2A2A),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _locErrorMessage!,
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              Expanded(
                child: Stack(
                  children: [
                    MapView(
                      initialCenter: _fallbackCenter,
                      initialZoom: _zoom,
                      centerOnBuild: center,
                      polyline: poly,
                      origemMarker: origem,
                      destinoMarker: loja,
                    ),

                    if (e != null)
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
                                heroTag: 'cancelar_corrida',
                                onPressed: () async {
                                  await _controller.cancelarCorrida();
                                  Modular.to.navigate('/home');
                                },
                                backgroundColor: const Color.fromARGB(
                                  200,
                                  88,
                                  86,
                                  86,
                                ),
                                label: 'Cancelar Corrida',
                                icon: Icons.close,
                              ),
                              ButtonsMapWidget(
                                heroTag: 'iniciar_corrida',
                                onPressed: () async {
                                  try {
                                    await _controller.aceitarEntrega();
                                  } catch (_) {}

                                  await _controller.confirmarColeta();

                                  Modular.to.navigate(
                                    '/map/entrega',
                                    arguments: {
                                      'entregaId': _controller.currentEntregaId,
                                    },
                                  );
                                },
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  0,
                                  0,
                                  0,
                                ).withOpacity(0.9),
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
