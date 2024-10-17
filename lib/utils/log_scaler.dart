import 'dart:math';

double logScaler(double value,
    {double logBase = 10,
    double maximum = double.infinity,
    double minimum = 0}) {
  double baseLog = log(logBase);
  double valueLog = log(value);
  var result = valueLog / baseLog - minimum;
  if (result < 0) {
    return 0;
  }
  if (result > maximum) {
    return maximum;
  }
  return result;
}
