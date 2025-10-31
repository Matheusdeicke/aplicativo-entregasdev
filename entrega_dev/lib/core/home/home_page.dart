import 'package:entrega_dev/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:entrega_dev/widgets/cards_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final primaryTextColor = Colors.grey[300];
    final secondaryTextColor = Colors.grey[500];

    return Scaffold(
      backgroundColor: AppColors.preto,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 30.0),
              child: Text(
                'Olá, bem vindo João!',
                style: TextStyle(
                  color: primaryTextColor,
                  fontFamily: 'Figtree',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Entrega disponíveis',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontFamily: 'Figtree',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  TextButton(
                    onPressed: () {

                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Finalizadas',
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontFamily: 'Figtree',
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          color: secondaryTextColor,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10.0),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return CardHomeWidget(
                    storeIcon: Icons.shopping_bag_outlined, 
                    storeName: 'SUBWAY',
                    distance: '8 km até a loja',
                    deliveryLocation: 'Local de entrega - Centro',
                    address: 'Rua 28 de Setembro, 120',
                    price: 'R\$ 25,00',
                    onTap: () {
                      Modular.to.navigate('/delivery');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}