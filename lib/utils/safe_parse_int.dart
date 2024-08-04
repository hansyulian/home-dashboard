int? safeParseInt(dynamic value) {
  try {
    return int.parse(value);
  } catch (err) {
    return null;
  }
}
