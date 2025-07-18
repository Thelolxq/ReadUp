import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomExpansionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;
  final Color color;

  const CustomExpansionTile({
    required this.color,
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
         border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2))
      ),
      child: ExpansionTile(
        onExpansionChanged: (isExpanding) {
          if (isExpanding) {
            HapticFeedback.lightImpact();
          }
        },
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        shape: const Border(),
        childrenPadding: const EdgeInsets.only(bottom: 10),
        children: children,
      ),
    );
  }
}