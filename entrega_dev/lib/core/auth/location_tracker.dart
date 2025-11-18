import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

class LocationTracker {
  static StreamSubscription<Position>? _sub;

  static Future<void> start(String uid) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) return;
    }
    if (perm == LocationPermission.deniedForever) {
      return;
    }

    final ref = FirebaseDatabase.instance.ref("entregadores_localizacao/$uid");

    _sub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((pos) async {
      final rua = await _buscarRua(pos.latitude, pos.longitude);

      ref.set({
        'lat': pos.latitude,
        'lon': pos.longitude,
        'rua': rua,
        'timestamp': ServerValue.timestamp,
      });
    });
  }

  static void stop() {
    _sub?.cancel();
  }
}

Future<String> _buscarRua(double lat, double lon) async {
  final url = Uri.parse(
    'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&zoom=17&addressdetails=1',
  );

  try {
    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'entregador_app',
        'Accept-Language': 'pt-BR',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final address = data['address'];

      if (address != null) {
        return address['road'] ??
            address['pedestrian'] ??
            address['street'] ??
            "Rua desconhecida";
      }
    }
  } catch (_) {}

  return "Rua desconhecida";
}
