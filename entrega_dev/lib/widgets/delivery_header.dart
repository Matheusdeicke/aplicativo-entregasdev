import 'package:flutter/material.dart';

class DeliveryHeader extends StatelessWidget {
  final String? imageUrl;
  final String title;     
  final String subtitle;  
  final String addressLine;
  final String? distanceText;
  final String? etaText;

  const DeliveryHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.addressLine,
    this.imageUrl,
    this.distanceText,
    this.etaText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF121212),
      padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: (imageUrl != null && imageUrl!.isNotEmpty)
                ? Image.network(
                    imageUrl!, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.local_shipping, color: Colors.white70),
                  )
                : const Icon(Icons.local_shipping, color: Colors.white70),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15,
                        ),
                      ),
                    ),
                    if (distanceText != null && distanceText!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(distanceText!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                Text(
                  addressLine,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                if (etaText != null && etaText!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(etaText!, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
