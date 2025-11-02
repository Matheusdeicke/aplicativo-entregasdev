import 'package:entrega_dev/core/auth/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../theme/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = Modular.get<LoginController>();

  @override
  void initState() {
    super.initState();
    controller.errorMessage.addListener(() {
      final error = controller.errorMessage.value;
      if (error != null && error.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-mail',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              Container(height: 40),
              TextField(
                controller: controller.passwordController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                obscureText: true,
              ),
              Container(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ValueListenableBuilder<bool>(
                  valueListenable: controller.isLoading,
                  builder: (context, isLoading, child) {
                    return isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                105,
                                100,
                                100,
                              ),
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              controller.login();
                            },
                            child: Text('Entrar'),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
