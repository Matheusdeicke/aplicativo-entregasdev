import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  final LatLng initialCenter;
  final double initialZoom;
  final List<LatLng> polyline; 
  final LatLng? origemMarker;
  final LatLng? destinoMarker;

  final LatLng? centerOnBuild;

  const MapView({
    super.key,
    required this.initialCenter,
    this.initialZoom = 13.8,
    this.polyline = const [],
    this.origemMarker,
    this.destinoMarker,
    this.centerOnBuild,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final mapController = MapController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.centerOnBuild != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        mapController.move(widget.centerOnBuild!, widget.initialZoom);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final poly = widget.polyline;

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: widget.initialCenter,
        initialZoom: widget.initialZoom,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
          subdomains: const ['a','b','c','d'],
          userAgentPackageName: 'dev.entrega_dev.app',
        ),
        if (poly.length >= 2)
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
            if (widget.origemMarker != null)
              Marker(
                point: widget.origemMarker!,
                width: 80, height: 80,
                child: const Icon(Icons.location_on, color: Color.fromARGB(255, 255, 17, 0), size: 40),
              ),
            if (widget.destinoMarker != null)
              Marker(
                point: widget.destinoMarker!,
                width: 80, height: 80,
                child: const Icon(Icons.store, color: Color.fromARGB(255, 255, 0, 0), size: 40),
              ),
          ],
        ),
        const RichAttributionWidget(attributions: [TextSourceAttribution('Mapa Teste')]),
      ],
    );
  }
}
