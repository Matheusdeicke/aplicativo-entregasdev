import 'package:flutter/material.dart';

class CardHomeWidget extends StatelessWidget {
  final IconData lojaIcon;
  final String? lojaImagem;
  final String lojaNome;
  final String distancia;
  final String localEntrega;
  final String endereco;
  final String preco;
  final VoidCallback? onTap;

  final bool disabled;
  final String? badgeText;

  const CardHomeWidget({
    super.key,
    this.lojaImagem,
    this.lojaIcon = Icons.storefront,
    required this.lojaNome,
    required this.distancia,
    required this.localEntrega,
    required this.endereco,
    required this.preco,
    this.onTap,
    this.disabled = false,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    final containerCor = Colors.grey[850];
    final primeiraCor = Colors.grey[100];
    final segundaCor = Colors.grey[500];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Opacity(
        opacity: disabled ? 0.45 : 1.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: containerCor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: (lojaImagem != null && lojaImagem!.isNotEmpty)
                      ? Image.network(
                          lojaImagem!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.local_shipping,
                            color: Colors.white70,
                            size: 36,
                          ),
                        )
                      : Icon(
                          lojaIcon,
                          color: Colors.grey,
                          size: 40,
                        ),
                ),
                if (badgeText != null && badgeText!.isNotEmpty)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.9),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        badgeText!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 16.0),

            // Infos
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
                  const SizedBox(height: 4.0),
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
                  const SizedBox(height: 4.0),
                  Text(
                    endereco,
                    style: TextStyle(
                      fontFamily: 'Figtree',
                      fontSize: 14,
                      color: segundaCor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
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

            const SizedBox(width: 10.0),

            if (onTap != null)
              Container(
                decoration: BoxDecoration(
                  color: containerCor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_forward, color: primeiraCor),
                  onPressed: disabled ? null : onTap,
                  splashRadius: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
