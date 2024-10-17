import 'dart:math';

String decimalAligner(double value, {int? left, int? right}) {
  var integer = value.floor().toString();
  var decimal = (value % 1 * pow(10, right ?? 0)).round().toString();
  var alignedInteger = left != null ? integer.padLeft(left, ' ') : integer;
  if (decimal == 0) {
    return alignedInteger;
  }
  return '${alignedInteger}.${decimal}';
}
