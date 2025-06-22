import 'package:flutter/material.dart';
import 'package:home_dashboard/modules/color_interpolator.dart';
import 'package:test/test.dart';

void main() {
  group('ColorInterpolator', () {
    test('interpolates colors correctly with ratio 0.0', () {
      final colorInterpolator = ColorInterpolator(
        const Color.fromARGB(255, 255, 0, 0), // Red
        const Color.fromARGB(255, 0, 0, 255), // Blue
      );
      final result = colorInterpolator.interpolate(0.0);
      expect(
          result,
          equals(const Color.fromARGB(
              255, 255, 0, 0))); // Should be the "from" color
    });

    test('interpolates colors correctly with ratio 1.0', () {
      final colorInterpolator = ColorInterpolator(
        const Color.fromARGB(255, 255, 0, 0), // Red
        const Color.fromARGB(255, 0, 0, 255), // Blue
      );
      final result = colorInterpolator.interpolate(1.0);
      expect(
          result,
          equals(const Color.fromARGB(
              255, 0, 0, 255))); // Should be the "to" color
    });

    test('interpolates colors correctly with ratio 0.5', () {
      final colorInterpolator = ColorInterpolator(
        const Color.fromARGB(255, 255, 0, 0), // Red
        const Color.fromARGB(255, 0, 0, 255), // Blue
      );
      final result = colorInterpolator.interpolate(0.5);
      expect(
          result,
          equals(const Color.fromARGB(
              255, 127, 0, 127))); // Should be halfway between Red and Blue
    });

    test('interpolates colors correctly with out-of-bounds ratio', () {
      final colorInterpolator = ColorInterpolator(
        const Color.fromARGB(255, 255, 0, 0), // Red
        const Color.fromARGB(255, 0, 0, 255), // Blue
      );
      final resultBelow = colorInterpolator.interpolate(-0.5);
      final resultAbove = colorInterpolator.interpolate(1.5);

      expect(
          resultBelow,
          equals(const Color.fromARGB(
              255, 255, 0, 0))); // Should be the "from" color
      expect(
          resultAbove,
          equals(const Color.fromARGB(
              255, 0, 0, 255))); // Should be the "to" color
    });
  });
}
