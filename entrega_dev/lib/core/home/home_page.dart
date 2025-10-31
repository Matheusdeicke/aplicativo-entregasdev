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
    final primeiraCor = Colors.grey[300];
    final segundaCor = Colors.grey[500];

    return Scaffold(
      backgroundColor: AppColors.preto,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 30.0),
              child: Text(
                'Olá, bem vindo João!',
                style: TextStyle(
                  color: primeiraCor,
                  fontFamily: 'Figtree',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Entrega disponíveis',
                    style: TextStyle(
                      color: primeiraCor,
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
                            color: segundaCor,
                            fontFamily: 'Figtree',
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 4),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward,
                            color: segundaCor,
                            size: 16,
                          ),
                          onPressed: () {
                            Modular.to.navigate('/delivery/finish');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return CardHomeWidget(
                    lojaIcon: Icons.shopping_bag_outlined, 
                    lojaNome: 'SUBWAY',
                    distancia: '8 km até a loja',
                    localEntrega: 'Local de entrega - Centro',
                    endereco: 'Rua 28 de Setembro, 120',
                    preco: 'R\$ 25,00',
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