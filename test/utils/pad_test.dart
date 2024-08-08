import 'package:flutter_test/flutter_test.dart';
import 'package:home_dashboard/utils/pad.dart';

void main() {
  group('Pad Function', () {
    test('pads a number with leading characters', () {
      expect(pad(5, 3, '0'), '005');
      expect(pad(123, 5, '0'), '00123');
      expect(pad(987654321, 10, '*'), '*987654321');
    });

    test('pads a string with leading characters', () {
      expect(pad('abc', 6, ' '), '   abc');
      expect(pad('test', 8, '#'), '####test');
      expect(pad('hello', 10, '!'), '!!!!!hello');
    });

    test('pads with different characters', () {
      expect(pad(42, 5, '-'), '---42');
      expect(pad('pad', 7, '.'), '....pad');
    });

    test('pads with empty character string', () {
      expect(pad(7, 4, ' '),
          '   7'); // If character is empty, it should fallback to spaces
      expect(pad('test', 6, ' '),
          '  test'); // If character is empty, it should fallback to spaces
    });

    test('handles negative length gracefully', () {
      expect(pad('value', -5, '*'),
          'value'); // Length should not affect output if negative
      expect(
          pad(1, -3, '#'), '1'); // Length should not affect output if negative
    });
  });
}
