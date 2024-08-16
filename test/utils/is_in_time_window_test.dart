import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_dashboard/models/time_window.dart';
import 'package:home_dashboard/utils/is_in_time_window.dart';

void main() {
  group('isInTimeWindow', () {
    test('should return true if the time is within the time window', () {
      // Arrange
      DateTime dateTime = DateTime(2024, 8, 16, 10, 0); // 10:00 AM
      TimeWindow timeWindow = TimeWindow(
        const TimeOfDay(hour: 8, minute: 0), // 08:00 AM
        const TimeOfDay(hour: 14, minute: 0), // 02:00 PM
      );

      // Act
      bool result = isInTimeWindow(dateTime, timeWindow);

      // Assert
      expect(result, true);
    });

    test('should return false if the time is outside the time window', () {
      // Arrange
      DateTime dateTime = DateTime(2024, 8, 16, 7, 0); // 07:00 AM
      TimeWindow timeWindow = TimeWindow(
        const TimeOfDay(hour: 8, minute: 0), // 08:00 AM
        const TimeOfDay(hour: 14, minute: 0), // 02:00 PM
      );

      // Act
      bool result = isInTimeWindow(dateTime, timeWindow);

      // Assert
      expect(result, false);
    });

    test('should handle cases where the time window crosses midnight', () {
      // Arrange
      DateTime dateTime = DateTime(2024, 8, 16, 1, 0); // 01:00 AM
      TimeWindow timeWindow = TimeWindow(
        const TimeOfDay(hour: 22, minute: 0), // 10:00 PM
        const TimeOfDay(hour: 6, minute: 0), // 06:00 AM
      );

      // Act
      bool result = isInTimeWindow(dateTime, timeWindow);

      // Assert
      expect(result, true);
    });

    test(
        'should return false if the time is outside a time window that crosses midnight',
        () {
      // Arrange
      DateTime dateTime = DateTime(2024, 8, 16, 8, 0); // 08:00 AM
      TimeWindow timeWindow = TimeWindow(
        const TimeOfDay(hour: 22, minute: 0), // 10:00 PM
        const TimeOfDay(hour: 6, minute: 0), // 06:00 AM
      );

      // Act
      bool result = isInTimeWindow(dateTime, timeWindow);

      // Assert
      expect(result, false);
    });
  });
}
