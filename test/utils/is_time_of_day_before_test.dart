import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:home_dashboard/utils/is_time_of_day_before.dart';

void main() {
  group('isTimeOfDayBefore', () {
    test(
        'should return true if a is before b on the same hour but earlier minute',
        () {
      // Arrange
      TimeOfDay a = const TimeOfDay(hour: 10, minute: 15);
      TimeOfDay b = const TimeOfDay(hour: 10, minute: 30);

      // Act
      bool result = isTimeOfDayBefore(a, b);

      // Assert
      expect(result, true);
    });

    test(
        'should return false if a is after b on the same hour but later minute',
        () {
      // Arrange
      TimeOfDay a = const TimeOfDay(hour: 10, minute: 45);
      TimeOfDay b = const TimeOfDay(hour: 10, minute: 30);

      // Act
      bool result = isTimeOfDayBefore(a, b);

      // Assert
      expect(result, false);
    });

    test('should return true if a is before b on an earlier hour', () {
      // Arrange
      TimeOfDay a = const TimeOfDay(hour: 9, minute: 45);
      TimeOfDay b = const TimeOfDay(hour: 10, minute: 15);

      // Act
      bool result = isTimeOfDayBefore(a, b);

      // Assert
      expect(result, true);
    });

    test('should return false if a is after b on a later hour', () {
      // Arrange
      TimeOfDay a = const TimeOfDay(hour: 11, minute: 0);
      TimeOfDay b = const TimeOfDay(hour: 10, minute: 30);

      // Act
      bool result = isTimeOfDayBefore(a, b);

      // Assert
      expect(result, false);
    });

    test('should return false if a is the same time as b', () {
      // Arrange
      TimeOfDay a = const TimeOfDay(hour: 10, minute: 30);
      TimeOfDay b = const TimeOfDay(hour: 10, minute: 30);

      // Act
      bool result = isTimeOfDayBefore(a, b);

      // Assert
      expect(result, false);
    });
  });
}
