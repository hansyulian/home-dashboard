double valueRatio(num value, num min, num max) {
  if (min == max) return 0;
  value = value.clamp(min, max);
  return (value - min) / (max - min);
}
