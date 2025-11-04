import 'package:entrega_dev/core/delivery/services/delivery_service.dart';
import 'package:entrega_dev/core/home/home_controller.dart';
import 'package:entrega_dev/core/delivery/models/delivery_model.dart';
import 'package:entrega_dev/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:entrega_dev/widgets/cards_home.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController controller;
  final _currency = NumberFormat.simpleCurrency(locale: 'pt_BR');

  @override
  void initState() {
    super.initState();
    controller = Modular.get<HomeController>();
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
          // Mensagem de bem vindo
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 30.0),
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

            // Mensagem de entregas disponiveis e botão para acessar entregas finalizadas
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    onPressed: () => Modular.to.navigate('/delivery/finish'),
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
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward, color: segundaCor, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Listagem das entregas disponiveis
            Expanded(
              child: StreamBuilder<List<DeliveryModel>>(
                stream: controller.entregasStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
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

                  final items = snapshot.data ?? const <DeliveryModel>[];
                  if (items.isEmpty) {
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
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                    itemBuilder: (context, index) {
                      final d = items[index];
                      final precoFmt = _currency.format(d.preco);

                      final auth = Modular.get<FirebaseAuth>();
                      final uid = auth.currentUser?.uid;

                      final isAccepted = d.status == 'aceita';
                      final acceptedByMe = isAccepted && d.acceptedBy == uid;
                      final acceptedByOther =
                          isAccepted &&
                          d.acceptedBy != null &&
                          d.acceptedBy != uid;

                      final disabled = acceptedByOther;
                      final badgeText = acceptedByMe
                          ? 'Aceita por você'
                          : (acceptedByOther ? 'Reservado' : null);

                      VoidCallback? onTap;
                      if (!disabled) {
                        onTap = () async {
                          if (uid == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Faça login para aceitar a entrega',
                                ),
                              ),
                            );
                            return;
                          }

                          final service = Modular.get<DeliveryService>();
                          try {
                            if (!acceptedByMe) {
                              await service.acceptDelivery(
                                entregaId: d.id,
                                uid: uid,
                              );
                            }
                            Modular.to.pushNamed(
                              '/map',
                              arguments: {'entregaId': d.id},
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        };
                      }

                      return CardHomeWidget(
                        lojaImagem: d.imagem,
                        lojaNome: d.lojaNome,
                        distancia: d.distancia,
                        localEntrega: d.localEntrega,
                        endereco: d.enderecoLoja,
                        preco: precoFmt,
                        onTap: onTap,
                        disabled:
                            disabled,
                        badgeText:
                            badgeText,
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
