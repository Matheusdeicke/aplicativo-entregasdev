import 'package:firebase_auth/firebase_auth.dart';

class HomeController {
  final FirebaseAuth _auth;
  
  HomeController(this._auth);

  late final String welcomeMessage;

  void loadUser() {
    final user = _auth.currentUser;
    String username = 'Usuário';

    if (user != null && user.email != null) {
      username = user.email!.split('@').first;
    }
    
    welcomeMessage = 'Olá, bem vindo $username!';
  }
}