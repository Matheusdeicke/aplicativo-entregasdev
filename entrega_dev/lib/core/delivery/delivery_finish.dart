import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DeliveryFinish extends StatefulWidget {
  const DeliveryFinish({super.key});

  @override
  State<DeliveryFinish> createState() => _DeliveryFinishState();
}

class _DeliveryFinishState extends State<DeliveryFinish> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Finish'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Modular.to.navigate('/home');
          },
          child: const Text('Voltar para Home'),
        ),
      ),

    );
  }
}