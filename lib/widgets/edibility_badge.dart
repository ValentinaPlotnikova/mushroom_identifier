import 'package:flutter/material.dart';

import '../core/constants.dart';

class EdibilityBadge extends StatelessWidget {
  final Edibility edibility;

  const EdibilityBadge({super.key, required this.edibility});

  Color get _color {
    switch (edibility) {
      case Edibility.edible:
        return const Color(0xFF2E7D32);
      case Edibility.conditionallyEdible:
        return const Color(0xFF9E9D24);
      case Edibility.inedible:
        return const Color(0xFF757575);
      case Edibility.poisonous:
        return const Color(0xFFE65100);
      case Edibility.deadlyPoisonous:
        return const Color(0xFFB71C1C);
    }
  }

  IconData get _icon {
    switch (edibility) {
      case Edibility.edible:
        return Icons.check_circle;
      case Edibility.conditionallyEdible:
        return Icons.info;
      case Edibility.inedible:
        return Icons.block;
      case Edibility.poisonous:
        return Icons.warning;
      case Edibility.deadlyPoisonous:
        return Icons.dangerous;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            edibility.labelRu,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
