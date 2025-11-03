import 'package:entrega_dev/widgets/buttons_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LatLng pontoInicial = LatLng(
      -29.690077344166916,
      -52.455172648394694,
    );

    final LatLng pontoEntrega = LatLng(
      -29.70307487982785, 
      -52.44509055525976
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Map Page')),

      body: FlutterMap(
        options: MapOptions(initialCenter: pontoInicial, initialZoom: 13.8),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
            subdomains: ['a', 'b', 'c', 'd'],
            userAgentPackageName: 'dev.entrega_dev.app',
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: [pontoInicial, pontoEntrega],
                color: const Color.fromARGB(255, 119, 118, 118),
                strokeWidth: 5.0,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: pontoInicial,
                width: 80,
                height: 80,
                child: Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
              Marker(
                point: pontoEntrega, 
                width: 80,
                height: 80,
                child: Icon(Icons.location_on, color: const Color.fromARGB(255, 60, 255, 0), size: 40)
              ,)
            ],
          ),

          RichAttributionWidget(
            attributions: [TextSourceAttribution('Mapa Teste')],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonsMapWidget(
                heroTag: 'cancelar_corrida',
                onPressed: () {
                  Modular.to.navigate('/home');
                },
                backgroundColor: Color.fromARGB(255, 88, 86, 86),
                label: 'Cancelar Corrida',
                icon: Icons.close,
              ),
              ButtonsMapWidget(
                heroTag: 'iniciar_corrida',
                onPressed: () {
                  // Ação ao iniciar a corrida
                },
                backgroundColor: Colors.green,
                label: 'Iniciar Corrida',
                icon: Icons.check,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
