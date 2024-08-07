import 'package:intl/intl.dart';

String numberValueDisplay(
  double value, {
  int? minimumDecimal,
  int? targetLength,
}) {
  int minimumFractionDigit = minimumDecimal ?? 2;
  int targetTotalLength = targetLength ?? 5;
  int integerValue = value.floor();
  int integerLength = integerValue.toString().length;

  int fractionDigits = minimumFractionDigit;
  if (targetTotalLength - integerLength > minimumFractionDigit) {
    fractionDigits = targetTotalLength - integerLength;
  }
  String formattedInteger = NumberFormat('#,###').format(integerValue);
  double decimals = value - integerValue;
  String decimalString = decimals.toStringAsFixed(fractionDigits).substring(2);
  return '$formattedInteger.$decimalString';
}
