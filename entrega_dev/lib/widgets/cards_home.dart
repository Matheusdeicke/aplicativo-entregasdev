import 'package:flutter/material.dart';
class CardHomeWidget extends StatelessWidget {
  final IconData lojaIcon;
  final String lojaNome;
  final String distancia;
  final String localEntrega;
  final String endereco;
  final String preco;
  final VoidCallback onTap;

  const CardHomeWidget({
    super.key,
    required this.lojaIcon,
    required this.lojaNome,
    required this.distancia,
    required this.localEntrega,
    required this.endereco,
    required this.preco,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final containerCor = Colors.grey[850];
    final primeiraCor = Colors.grey[100];
    final segundaCor = Colors.grey[500];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: containerCor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(
              lojaIcon,
              color: Colors.green,
              size: 40,
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$lojaNome | $distancia',
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 14,
                    color: segundaCor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.0),
                Text(
                  localEntrega,
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 16,
                    color: primeiraCor,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.0),
                Text(
                  endereco,
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 14,
                    color: segundaCor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.0),
                Text(
                  preco,
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 18,
                    color: primeiraCor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.0),
          Container(
            decoration: BoxDecoration(
              color: containerCor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_forward, color: primeiraCor),
              onPressed: onTap,
              splashRadius: 20,
            ),
          ),
        ],
      ),
    );
  }
}