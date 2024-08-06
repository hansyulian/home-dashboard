double? safeParseDouble(dynamic value) {
  if (value is double) {
    return value;
  } else if (value is int) {
    return value.toDouble();
  } else if (value is String) {
    try {
      return double.parse(value);
    } catch (e) {
      return null;
    }
  } else {
    return null;
  }
}
