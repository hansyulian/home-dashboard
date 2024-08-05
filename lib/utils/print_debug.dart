import 'package:flutter/foundation.dart';

void printDebug(String content) {
  if (kDebugMode) {
    print(content);
  }
}
