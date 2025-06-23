import 'package:intl/intl.dart';

String numberValueDisplay(
  double value, {
  int? minimumDecimal,
  int? targetLength,
}) {
  int minimumFractionDigit = minimumDecimal ?? 2;
  int targetTotalLength = targetLength ?? 5;

  // Determine how many digits are before the decimal point
  String integerPart = value.truncate().toString();
  int integerLength = integerPart.length;

  int fractionDigits =
      (targetTotalLength - integerLength > minimumFractionDigit)
          ? targetTotalLength - integerLength
          : minimumFractionDigit;

  // Format full number with both integer and fraction digits
  String fractionString = fractionDigits > 0 ? '.${'0' * fractionDigits}' : '';
  NumberFormat formatter = NumberFormat.currency(
    decimalDigits: fractionDigits,
    symbol: '',
    customPattern: '#,##0$fractionString',
  );

  return formatter.format(value).trim();
}
