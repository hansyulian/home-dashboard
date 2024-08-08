import 'package:flutter_test/flutter_test.dart';
import 'package:home_dashboard/utils/safe_parse_double.dart';

void main() {
  group('safeParseDouble Function', () {
    test('parses double values correctly', () {
      expect(safeParseDouble(3.14), 3.14);
      expect(safeParseDouble(0.0), 0.0);
    });

    test('parses int values as doubles', () {
      expect(safeParseDouble(5), 5.0);
      expect(safeParseDouble(-10), -10.0);
    });

    test('parses valid string values to doubles', () {
      expect(safeParseDouble('3.14'), 3.14);
      expect(safeParseDouble('0'), 0.0);
      expect(safeParseDouble('123.45'), 123.45);
    });

    test('returns null for invalid string values', () {
      expect(safeParseDouble('abc'), isNull);
      expect(safeParseDouble('12.34abc'), isNull);
      expect(safeParseDouble(''), isNull);
    });

    test('returns null for non-numeric types', () {
      expect(safeParseDouble([]), isNull);
      expect(safeParseDouble({}), isNull);
      expect(safeParseDouble(null), isNull);
    });
  });
}
