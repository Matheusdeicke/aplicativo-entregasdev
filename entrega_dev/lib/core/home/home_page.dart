import 'package:entrega_dev/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.preto,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: Text(
                'Olá, bem vindo João!',
                style: TextStyle(
                  color: const Color.fromARGB(255, 105, 100, 100),
                  fontFamily: 'Figtree',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                'Entrega disponíveis',
                style: TextStyle(
                  color: const Color.fromARGB(255, 105, 100, 100),
                  fontFamily: 'Figtree',
                  fontSize: 20,
                ),
              ),
              Container(width: 150),
              Text(
                'Finalizadas',
                style: TextStyle(
                  color: const Color.fromARGB(255, 105, 100, 100),
                  fontFamily: 'Figtree',
                  fontSize: 20,
                ),
              ),
              IconButton(
                onPressed: () {
                  
                }, 
                icon: Icon(Icons.arrow_right_alt),
              ),
            ],
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    'SUBWAY',
                    style: TextStyle(fontFamily: 'Figtree', fontSize: 16),
                  ),
                  subtitle: Text(
                    'R\$ 25,00',
                    style: TextStyle(
                      fontFamily: 'Figtree',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on),
                          SizedBox(width: 8.0),
                          Text(
                            'Rua 28 de Setembro, 120',
                            style: TextStyle(
                              fontFamily: 'Figtree',
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(Icons.access_time),
                            SizedBox(width: 8.0),
                            Text(
                              '8 Km até a loja',
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          Modular.to.navigate('/map');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Componentizar as rows
