import 'package:flutter/material.dart';

class FoodIcon extends StatelessWidget {
  final String foodName;
  final double size;

  const FoodIcon({
    super.key,
    required this.foodName,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color backgroundColor;
    Color iconColor;

    switch (foodName.toLowerCase()) {
      case 'nasi goreng':
        iconData = Icons.rice_bowl;
        backgroundColor = Colors.orange.shade100;
        iconColor = Colors.orange.shade800;
        break;
      case 'ayam bakar':
        iconData = Icons.restaurant_menu;
        backgroundColor = Colors.red.shade100;
        iconColor = Colors.red.shade800;
        break;
      case 'es teh manis':
        iconData = Icons.local_cafe;
        backgroundColor = Colors.brown.shade100;
        iconColor = Colors.brown.shade800;
        break;
      case 'bakso':
        iconData = Icons.soup_kitchen;
        backgroundColor = Colors.blue.shade100;
        iconColor = Colors.blue.shade800;
        break;
      case 'jus jeruk':
        iconData = Icons.local_bar;
        backgroundColor = Colors.orange.shade200;
        iconColor = Colors.deepOrange.shade800;
        break;
      default:
        iconData = Icons.restaurant;
        backgroundColor = Colors.grey.shade100;
        iconColor = Colors.grey.shade800;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        iconData,
        size: size * 0.6,
        color: iconColor,
      ),
    );
  }
}