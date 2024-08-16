import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_dashboard/utils/get_next_time_of_day.dart';

void main() {
  group('getNextTimeOfDay', () {
    test('returns today\'s DateTime when time is in the future', () {
      TimeOfDay futureTime = TimeOfDay(
          hour: DateTime.now().hour + 1, minute: DateTime.now().minute);

      DateTime result = getNextTimeOfDay(futureTime);

      expect(result.day, equals(DateTime.now().day));
      expect(result.hour, equals(futureTime.hour));
      expect(result.minute, equals(futureTime.minute));
    });

    test('returns tomorrow\'s DateTime when time is in the past', () {
      TimeOfDay pastTime = TimeOfDay(
          hour: DateTime.now().hour - 1, minute: DateTime.now().minute);

      DateTime result = getNextTimeOfDay(pastTime);

      expect(result.day, equals(DateTime.now().day + 1));
      expect(result.hour, equals(pastTime.hour));
      expect(result.minute, equals(pastTime.minute));
    });

    test('returns tomorrow\'s DateTime when time is exactly now', () {
      TimeOfDay currentTime =
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

      DateTime result = getNextTimeOfDay(currentTime);

      expect(result.day, equals(DateTime.now().day + 1));
      expect(result.hour, equals(currentTime.hour));
      expect(result.minute, equals(currentTime.minute));
    });
  });
}
