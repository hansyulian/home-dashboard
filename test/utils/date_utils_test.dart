import 'package:flutter_test/flutter_test.dart';
import 'package:home_dashboard/utils/date_utils.dart';

void main() {
  group('Date Utilities', () {
    test('getDayOfWeek returns correct day of the week', () {
      expect(getDayOfWeek(1), 'Monday');
      expect(getDayOfWeek(2), 'Tuesday');
      expect(getDayOfWeek(3), 'Wednesday');
      expect(getDayOfWeek(4), 'Thursday');
      expect(getDayOfWeek(5), 'Friday');
      expect(getDayOfWeek(6), 'Saturday');
      expect(getDayOfWeek(7), 'Sunday');
    });

    test('getMonth returns correct month', () {
      expect(getMonth(1), 'January');
      expect(getMonth(2), 'February');
      expect(getMonth(3), 'March');
      expect(getMonth(4), 'April');
      expect(getMonth(5), 'May');
      expect(getMonth(6), 'June');
      expect(getMonth(7), 'July');
      expect(getMonth(8), 'August');
      expect(getMonth(9), 'September');
      expect(getMonth(10), 'October');
      expect(getMonth(11), 'November');
      expect(getMonth(12), 'December');
    });
  });
}
