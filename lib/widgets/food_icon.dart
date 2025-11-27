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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    IconData iconData;
    Color backgroundColor;
    Color iconColor;

    switch (foodName.toLowerCase()) {
      case 'nasi goreng':
        iconData = Icons.rice_bowl;
        backgroundColor = isDarkMode ? Colors.orange.shade900 : Colors.orange.shade100;
        iconColor = isDarkMode ? Colors.orange.shade200 : Colors.orange.shade800;
        break;
      case 'ayam bakar':
        iconData = Icons.restaurant_menu;
        backgroundColor = isDarkMode ? Colors.red.shade900 : Colors.red.shade100;
        iconColor = isDarkMode ? Colors.red.shade200 : Colors.red.shade800;
        break;
      case 'es teh manis':
        iconData = Icons.local_cafe;
        backgroundColor = isDarkMode ? Colors.brown.shade900 : Colors.brown.shade100;
        iconColor = isDarkMode ? Colors.brown.shade200 : Colors.brown.shade800;
        break;
      case 'bakso':
        iconData = Icons.soup_kitchen;
        backgroundColor = isDarkMode ? Colors.blue.shade900 : Colors.blue.shade100;
        iconColor = isDarkMode ? Colors.blue.shade200 : Colors.blue.shade800;
        break;
      case 'jus jeruk':
        iconData = Icons.local_bar;
        backgroundColor = isDarkMode ? Colors.deepOrange.shade900 : Colors.orange.shade200;
        iconColor = isDarkMode ? Colors.deepOrange.shade200 : Colors.deepOrange.shade800;
        break;
      default:
        iconData = Icons.restaurant;
        backgroundColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100;
        iconColor = isDarkMode ? Colors.grey.shade300 : Colors.grey.shade800;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
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