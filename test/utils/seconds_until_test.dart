import 'package:flutter_test/flutter_test.dart';
import 'package:home_dashboard/utils/seconds_until.dart';

void main() {
  group('secondsUntil', () {
    test('should return the difference in seconds if dateTime is in the future',
        () {
      // Arrange
      DateTime futureDateTime = DateTime.now().add(const Duration(seconds: 10));

      // Act
      int result = secondsUntil(futureDateTime);

      // Assert
      expect(result, 10);
    });

    test('should return 0 if dateTime is in the past', () {
      // Arrange
      DateTime pastDateTime =
          DateTime.now().subtract(const Duration(seconds: 10));

      // Act
      int result = secondsUntil(pastDateTime);

      // Assert
      expect(result, 0);
    });

    test('should return 0 if dateTime is exactly now', () {
      // Arrange
      DateTime nowDateTime = DateTime.now();

      // Act
      int result = secondsUntil(nowDateTime);

      // Assert
      expect(result, 0);
    });
  });
}
