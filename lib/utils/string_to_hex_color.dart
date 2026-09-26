import 'dart:ui';

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
