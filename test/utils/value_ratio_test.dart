import 'package:flutter_test/flutter_test.dart';
import 'package:home_dashboard/utils/value_ratio.dart';

void main() {
  group('valueRatio', () {
    test('calculates ratio correctly within bounds', () {
      expect(valueRatio(5, 0, 10), equals(0.5));
      expect(valueRatio(7, 0, 10), equals(0.7));
      expect(valueRatio(0, 0, 10), equals(0.0));
      expect(valueRatio(10, 0, 10), equals(1.0));
    });

    test('clamps values below min', () {
      expect(valueRatio(-5, 0, 10), equals(0.0));
      expect(valueRatio(-5, -10, 10), equals(0.25));
    });

    test('clamps values above max', () {
      expect(valueRatio(15, 0, 10), equals(1.0));
      expect(valueRatio(25, 10, 20), equals(1.0));
    });

    test('handles zero range (min == max)', () {
      expect(valueRatio(5, 5, 5),
          equals(0.0)); // Any value within this range should return 0
      expect(valueRatio(5, 5, 5),
          equals(valueRatio(5, 5, 5))); // Should still return 0
    });

    test('handles negative range values', () {
      expect(valueRatio(-5, -10, 0), equals(0.5));
      expect(valueRatio(-15, -10, 0), equals(0.0));
      expect(valueRatio(-5, -10, -5), equals(1.0));
    });
  });
}
