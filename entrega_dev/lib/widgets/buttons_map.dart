import 'package:flutter/material.dart';

class ButtonsMapWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final String heroTag;
  final Color backgroundColor;

  const ButtonsMapWidget({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.heroTag,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: heroTag,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      label: Text(label, style: TextStyle(color: Colors.white)),
      icon: Icon(icon, color: Colors.white),
    );
  }
}
