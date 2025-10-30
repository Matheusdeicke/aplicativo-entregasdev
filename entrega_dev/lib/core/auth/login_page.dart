import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../theme/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.preto,

      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Entregas DEV',
                style: TextStyle(
                  color: const Color.fromARGB(255, 105, 100, 100),
                  fontFamily: 'Figtree',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(height: 60),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-mail',
                ),
              ),
              Container(height: 40),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                ),
                obscureText: true,
              ),
              Container(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 105, 100, 100),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Modular.to.navigate('/home');
                  },
                  child: Text('Entrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
