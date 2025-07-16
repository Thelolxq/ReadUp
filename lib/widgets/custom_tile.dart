import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomExpansionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const CustomExpansionTile({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
       decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
         border: Border.all(color: Colors.grey[200]!)
      ),
      child: ExpansionTile(
        onExpansionChanged: (isExpanding) {
          if (isExpanding) {
            HapticFeedback.lightImpact(); // Pequeña vibración al abrir
          }
        },
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        shape: const Border(), // Quita el borde por defecto del ExpansionTile
        childrenPadding: const EdgeInsets.only(bottom: 10),
        children: children,
      ),
    );
  }
}