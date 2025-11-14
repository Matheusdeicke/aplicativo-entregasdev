import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class PresenceService {
  final FirebaseDatabase _db;
  final FirebaseAuth _auth;

  StreamSubscription<DatabaseEvent>? _connectedSubscription;

  PresenceService(this._db, this._auth);

  Future<void> iniciaPresencaEntregador() async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('PresenceService.iniciaPresencaEntregador: user == null');
      return;
    }

    final entregadorUid = user.uid;
    final userStatusDatabaseRef =
        _db.ref('presence/entregadores/$entregadorUid');

    final connectedRef = _db.ref('.info/connected');

    // Garante que só existe um listener ativo
    await _connectedSubscription?.cancel();

    _connectedSubscription = connectedRef.onValue.listen(
      (event) async {
        final connected = event.snapshot.value == true;
        if (!connected) {
          debugPrint('PresenceService: dispositivo desconectado do RTDB');
          return;
        }

        try {
          await userStatusDatabaseRef.onDisconnect().set({
            'state': 'offline',
            'last_changed': ServerValue.timestamp,
          });

          await userStatusDatabaseRef.set({
            'state': 'online',
            'last_changed': ServerValue.timestamp,
          });

          debugPrint(
            'PresenceService: presença ONLINE setada para $entregadorUid',
          );
        } catch (e) {
          debugPrint('PresenceService: erro ao setar presença: $e');
        }
      },
      onError: (e) {
        debugPrint('PresenceService: erro no listener de .info/connected: $e');
      },
    );
  }

  Future<void> setarOffline() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final entregadorUid = user.uid;
    final userStatusDatabaseRef =
        _db.ref('presence/entregadores/$entregadorUid');

    await userStatusDatabaseRef.set({
      'state': 'offline',
      'last_changed': ServerValue.timestamp,
    });

    await _connectedSubscription?.cancel();
    _connectedSubscription = null;

    debugPrint('PresenceService: presença OFFLINE setada para $entregadorUid');
  }

  /// Stream para usar no dashboard (total de entregadores online)
  Stream<int> observarEntregadoresOnline() {
    final entregadoresRef = _db.ref('presence/entregadores');

    return entregadoresRef.onValue.map((event) {
      final data = event.snapshot.value;

      if (data is Map) {
        int count = 0;
        for (final value in data.values) {
          if (value is Map && value['state'] == 'online') {
            count++;
          }
        }
        return count;
      }

      return 0;
    });
  }

  Future<void> dispose() async {
    await _connectedSubscription?.cancel();
    _connectedSubscription = null;
  }
}
