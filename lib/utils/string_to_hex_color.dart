import 'dart:ui';
import 'package:flutter/widgets.dart';

Color stringToColor(String input) {
  int hash = 0;

  // 1. Initial hash calculation (djb2)
  for (int i = 0; i < input.length; i++) {
    hash = input.codeUnitAt(i) + ((hash << 5) - hash);
  }

  // 2. Apply a bit-mixing finalizer (Avalanche Effect)
  // This completely scrambles similar inputs (like 8.8.8.8 and 1.1.1.1)
  hash ^= hash >> 16;
  hash = (hash * 0x85ebca6b) & 0xFFFFFFFF;
  hash ^= hash >> 13;
  hash = (hash * 0xc2b2ae35) & 0xFFFFFFFF;
  hash ^= hash >> 16;

  // 3. Restrict to 24 bits and return the Flutter Color
  int colorInt = hash.abs() & 0xFFFFFF;
  return Color(colorInt + 0xFF000000);
}

Color stringToLightColor(String input) {
  int hash = 0;

  // 1. Initial hash (djb2), kept to 32 bits so it behaves the same on every platform
  for (int i = 0; i < input.length; i++) {
    hash = (input.codeUnitAt(i) + ((hash << 5) - hash)) & 0xFFFFFFFF;
  }

  // 2. Avalanche finalizer
  hash ^= hash >> 16;
  hash = (hash * 0x85ebca6b) & 0xFFFFFFFF;
  hash ^= hash >> 13;
  hash = (hash * 0xc2b2ae35) & 0xFFFFFFFF;
  hash ^= hash >> 16;

  // 3. Pick HSL values from different bit ranges of the hash
  final double hue = (hash % 360).toDouble(); // 0..359
  final double saturation = 0.55 + ((hash >> 9) % 31) / 100; // 0.55..0.85
  final double lightness = 0.80 + ((hash >> 17) % 11) / 100; // 0.80..0.90

  return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
}
