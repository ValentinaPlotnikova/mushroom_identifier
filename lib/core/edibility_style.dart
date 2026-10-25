import 'package:flutter/material.dart';

import 'constants.dart';

class EdibilityStyle {
  EdibilityStyle._();

  static const Color green = Color(0xFF2E7D32);
  static const Color orange = Color(0xFFEF6C00);
  static const Color red = Color(0xFFC62828);

  static Color color(Edibility edibility) {
    switch (edibility) {
      case Edibility.edible:
        return green;
      case Edibility.conditionallyEdible:
      case Edibility.inedible:
        return orange;
      case Edibility.poisonous:
      case Edibility.deadlyPoisonous:
        return red;
    }
  }

  static bool isDangerous(Edibility edibility) {
    return edibility == Edibility.poisonous ||
        edibility == Edibility.deadlyPoisonous;
  }

  static IconData icon(Edibility edibility) {
    if (isDangerous(edibility)) return Icons.dangerous;
    switch (edibility) {
      case Edibility.edible:
        return Icons.check_circle;
      case Edibility.conditionallyEdible:
      case Edibility.inedible:
        return Icons.info;
      case Edibility.poisonous:
      case Edibility.deadlyPoisonous:
        return Icons.dangerous;
    }
  }
}
