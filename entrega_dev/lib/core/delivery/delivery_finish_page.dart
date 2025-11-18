import 'package:entrega_dev/core/delivery/delivery_controller.dart';
import 'package:entrega_dev/core/delivery/models/delivery_model.dart';
import 'package:entrega_dev/theme/colors.dart';
import 'package:entrega_dev/widgets/cards_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DeliveryFinish extends StatefulWidget {
  const DeliveryFinish({super.key});

  @override
  State<DeliveryFinish> createState() => _DeliveryFinishState();
}

class _DeliveryFinishState extends State<DeliveryFinish> {
  late final DeliveryController controller;

  @override
  void initState() {
    super.initState();
    controller = Modular.get<DeliveryController>();
  }

  String _formatBRL(num value) {
    final str = value.toStringAsFixed(2).replaceAll('.', ',');
    return 'R\$ $str';
  }

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
                  const SizedBox(width: 4),
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

            // Ganhos totais
            StreamBuilder<double>(
              stream: controller.totalGanhosStream,
              builder: (context, snap) {
                final total = snap.data ?? 0.0;
                return Row(
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
                    const SizedBox(width: 40),
                    Text(
                      _formatBRL(total),
                      style: TextStyle(
                        color: segundaCor,
                        fontFamily: 'Figtree',
                        fontSize: 24,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 8),

            // Lista de finalizadas
            Expanded(
              child: StreamBuilder<List<DeliveryModel>>(
                stream: controller.entregasFinalizadasStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar entregas finalizadas\n${snapshot.error}',
                        style: TextStyle(
                          color: segundaCor,
                          fontFamily: 'Figtree',
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  final items = snapshot.data ?? const <DeliveryModel>[];
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhuma entrega finalizada',
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
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                    itemBuilder: (context, index) {
                      final d = items[index];

                      return CardHomeWidget(
                        lojaImagem: d.imagem,
                        lojaIcon: Icons.shopping_bag_outlined,
                        lojaNome: d.lojaNome,
                        distancia: d.distancia,
                        localEntrega: d.localEntrega,
                        endereco: d.enderecoLoja,
                        preco: _formatBRL(d.preco),
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
