import 'package:flutter_test/flutter_test.dart';
import 'package:home_dashboard/utils/number_value_display.dart';

void main() {
  group('number value display processor', () {
    test('524859.288248 -> 524,859.29', () {
      expect(numberValueDisplay(524859.288248), '524,859.29');
    });
    test('0.288258 -> 0.2883', () {
      expect(numberValueDisplay(0.288258), '0.2883');
    });
    test('12.288248 -> 12.288', () {
      expect(numberValueDisplay(12.288248), '12.288');
    });
    test('1264.288248 -> 1,264.3', () {
      expect(numberValueDisplay(1264.288248), '1,264.29');
    });
    test('1264.288248 with minimum decimal 3 -> 1,264.288', () {
      expect(numberValueDisplay(1264.288248, minimumDecimal: 3), '1,264.288');
    });
    test('1264.288248 target length 8 -> 1,264.2882', () {
      expect(numberValueDisplay(1264.288248, targetLength: 8), '1,264.2882');
    });

    test('123.123 target length 1 minimum decimal 0 -> 123', () {
      expect(numberValueDisplay(123.123, targetLength: 1, minimumDecimal: 0),
          '123');
    });
  });
}
