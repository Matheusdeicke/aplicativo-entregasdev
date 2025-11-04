import 'package:entrega_dev/theme/colors.dart';
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
    final primeiraCor = Colors.grey[300];
    final segundaCor = Colors.grey[500];

    return Scaffold(
      backgroundColor: AppColors.preto,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () => Modular.to.navigate('/home'),
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: segundaCor, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Voltar para a tela de entregas',
                    style: TextStyle(
                      color: segundaCor,
                      fontFamily: 'Figtree',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 30.0),
              child: Text(
                'Entregas finalizadas',
                style: TextStyle(
                  color: primeiraCor,
                  fontFamily: 'Figtree',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ganhos Totais',
                  style: TextStyle(
                    color: segundaCor,
                    fontFamily: 'Figtree',
                    fontSize: 24,
                  ),
                ),
                SizedBox(width: 40),
                Text(
                  'R\$ 50',
                  style: TextStyle(
                    color: segundaCor,
                    fontFamily: 'Figtree',
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
