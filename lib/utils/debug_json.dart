import 'dart:convert';

import 'package:home_dashboard/utils/print_debug.dart';

void debugJson(dynamic jsonObject, {String label = ''}) {
  String prettyJson = const JsonEncoder.withIndent('  ').convert(jsonObject);
  printDebug(prettyJson);
}
