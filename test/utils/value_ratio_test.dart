import 'package:flutter_test/flutter_test.dart';
import 'package:home_dashboard/utils/value_ratio.dart';

void main() {
  group('valueRatio', () {
    test('Returns 0 if value is less than min', () {
      expect(valueRatio(2, 5, 10), equals(0));
    });

    test('Returns 1 if value is greater than max', () {
      expect(valueRatio(15, 5, 10), equals(1));
    });

    test('Returns the correct ratio if value is between min and max', () {
      expect(valueRatio(7, 5, 10), closeTo(0.6, 0.001));
      expect(valueRatio(9, 5, 10), closeTo(0.2, 0.001));
    });

    test('Returns 0 if value equals min', () {
      expect(valueRatio(5, 5, 10), equals(1));
    });

    test('Returns 1 if value equals max', () {
      expect(valueRatio(10, 5, 10), equals(0));
    });

    test('Returns 0.5 for midpoint value', () {
      expect(valueRatio(7.5, 5, 10), closeTo(0.5, 0.001));
    });
  });
}
