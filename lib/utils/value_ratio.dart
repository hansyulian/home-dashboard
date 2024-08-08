double valueRatio(double value, double min, double max) {
  if (value < min) {
    return 0;
  }
  if (value > max) {
    return 1;
  }
  return (max - value) / (max - min);
}
