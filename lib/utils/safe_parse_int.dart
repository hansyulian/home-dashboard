int? safeParseInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value == null) {
    return null;
  }
  try {
    return int.parse(value);
  } catch (err) {
    print('parseIntError $err');
    return null;
  }
}
