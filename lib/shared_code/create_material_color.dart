import 'package:flutter/material.dart';

MaterialColor createMaterialColor(Color color) {
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    final double strength = 0.1 * i;
    final double deltaStrength = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((deltaStrength < 0 ? r : (255 - r)) * deltaStrength).round(),
      g + ((deltaStrength < 0 ? g : (255 - g)) * deltaStrength).round(),
      b + ((deltaStrength < 0 ? b : (255 - b)) * deltaStrength).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}