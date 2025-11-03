import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomeController {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  late final String welcomeMessage;
  late final Stream<QuerySnapshot> entregasStream;

  HomeController(this._auth) {
    final user = _auth.currentUser;
    String username = 'Usuário';

    if (user != null && user.email != null) {
      username = user.email!.split('@').first;
    }
    
    welcomeMessage = 'Olá, bem vindo $username!';

    entregasStream = _firestore
        .collection('entregasteste')
        // .where('status', isEqualTo: 'pendente')
        // .orderBy('criadoEm', descending: false)
        .snapshots();
  }
}