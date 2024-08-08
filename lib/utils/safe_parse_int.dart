import 'package:home_dashboard/utils/print_debug.dart';

int? safeParseInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value == null) {
    return null;
  }
  try {
    return int.parse(value);
  } catch (e) {
    printDebug('$e');
    return null;
  }
}
