import 'package:flutter_test/flutter_test.dart';
import 'package:home_dashboard/utils/safe_parse_int.dart';

void main() {
  group('safeParseInt Function', () {
    test('parses int values correctly', () {
      expect(safeParseInt(42), 42);
      expect(safeParseInt(-1), -1);
      expect(safeParseInt(0), 0);
    });

    test('parses valid string values to int', () {
      expect(safeParseInt('123'), 123);
      expect(safeParseInt('-456'), -456);
      expect(safeParseInt('0'), 0);
    });

    test('returns null for invalid string values', () {
      expect(safeParseInt('abc'), isNull);
      expect(safeParseInt('123abc'), isNull);
      expect(safeParseInt(''), isNull);
    });

    test('returns null for non-numeric types', () {
      expect(safeParseInt([]), isNull);
      expect(safeParseInt({}), isNull);
      expect(safeParseInt(null), isNull);
    });

    test('handles exceptions and prints debug messages', () {
      // To verify that exceptions are handled and debug messages are printed,
      // you can use a mock or stub for printDebug.
      // You might need to update the implementation to allow mocking or checking the debug output.
    });
  });
}
