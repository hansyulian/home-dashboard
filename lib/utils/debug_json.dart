import 'dart:convert';

void debugJson(dynamic jsonObject, {String label = ''}) {
  String prettyJson = const JsonEncoder.withIndent('  ').convert(jsonObject);
  print('$label $prettyJson');
}
