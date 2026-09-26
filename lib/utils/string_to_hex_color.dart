import 'dart:ui';

Color stringToColor(String input) {
  int hash = 0;

  // Simple djb2-style hash algorithm
  for (int i = 0; i < input.length; i++) {
    hash = input.codeUnitAt(i) + ((hash << 5) - hash);
  }

  // Ensure the hash is positive and restricted to 24 bits (0 to 16777215)
  int colorInt = hash.abs() & 0xFFFFFF;

  // Return a Flutter Color object, adding 0xFF000000 for full opacity
  return Color(colorInt + 0xFF000000);
}
