import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_dashboard/models/time_window.dart';

void main() {
  group('TimeWindow', () {
    test('fromJson should create a TimeWindow from JSON', () {
      // Arrange
      Map<String, dynamic> json = {
        'start': '08:30',
        'end': '14:45',
      };

      // Act
      TimeWindow timeWindow = TimeWindow.fromJson(json);

      // Assert
      expect(timeWindow.start, const TimeOfDay(hour: 8, minute: 30));
      expect(timeWindow.end, const TimeOfDay(hour: 14, minute: 45));
    });

    test('toJson should convert a TimeWindow to JSON', () {
      // Arrange
      TimeWindow timeWindow = TimeWindow(
        const TimeOfDay(hour: 8, minute: 30),
        const TimeOfDay(hour: 14, minute: 45),
      );

      // Act
      Map<String, dynamic> json = timeWindow.toJson();

      // Assert
      expect(json, {
        'start': '08:30',
        'end': '14:45',
      });
    });
  });
}
