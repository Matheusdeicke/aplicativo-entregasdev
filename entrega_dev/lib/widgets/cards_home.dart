import 'package:flutter/material.dart';
class CardHomeWidget extends StatelessWidget {
  final IconData storeIcon;
  final String storeName;
  final String distance;
  final String deliveryLocation;
  final String address;
  final String price;
  final VoidCallback onTap;

  const CardHomeWidget({
    super.key,
    required this.storeIcon,
    required this.storeName,
    required this.distance,
    required this.deliveryLocation,
    required this.address,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final containerColor = Colors.grey[850];
    final secondaryTextColor = Colors.grey[500];
    final primaryTextColor = Colors.grey[100];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(
              storeIcon,
              color: Colors.green,
              size: 40,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$storeName | $distance',
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 14,
                    color: secondaryTextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  deliveryLocation,
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 16,
                    color: primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  address,
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 14,
                    color: secondaryTextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8.0),
                Text(
                  price,
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 18,
                    color: primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          Container(
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_forward, color: primaryTextColor),
              onPressed: onTap,
              splashRadius: 20,
            ),
          ),
        ],
      ),
    );
  }
}