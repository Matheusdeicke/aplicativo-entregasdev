import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega_dev/core/home/home_controller.dart';
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

  late final HomeController controller = Modular.get<HomeController>();

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
                controller.welcomeMessage,
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
                    'Entregas disponíveis',
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
              child: StreamBuilder(
                stream: controller.entregasStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator()
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar entregas',
                        style: TextStyle(
                          color: segundaCor,
                          fontFamily: 'Figtree',
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhuma entrega disponível',
                        style: TextStyle(
                          color: segundaCor,
                          fontFamily: 'Figtree',
                          fontSize: 16,
                        ),
                      ),
                    );
                }
            
                return ListView.separated(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 16.0),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final lojaIcon = (data['imagem'] as String?) ?? 'img';
                    final lojaNome = (data['lojaNome'] as String?) ?? 'Loja';
                    final distancia = (data['distancia'] as String?) ?? '-';
                    final localEntrega = (data['localEntrega'] as String?) ?? '-';
                    final enderecoLoja = (data['enderecoLoja'] as String?) ?? '-';
                    final preco = (data['preco'] as num?)?.toStringAsFixed(2) ?? '0,00';

                    return CardHomeWidget(
                      lojaIcon: Icons.shopping_bag_outlined,
                      lojaNome: lojaNome,
                      distancia: distancia,
                      localEntrega: localEntrega,
                      endereco: enderecoLoja,
                      preco: 'R\$ $preco',
                      onTap: () {
                        Modular.to.navigate('/delivery', arguments: {
                          'entregaId': docs[index].id,
                        });
                      },
                    );
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