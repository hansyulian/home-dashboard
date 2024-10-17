import 'dart:convert';

import 'package:home_dashboard/models/home_server_info.dart';
import 'package:home_dashboard/utils/print_debug.dart';
import 'package:http/http.dart' as http;

class HomeServerInfoDriver {
  final String apiEndpoint;

  HomeServerInfoDriver(this.apiEndpoint);

  Future<HomeServerInfo> safeRetrieve() async {
    final url = Uri.parse(apiEndpoint);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return HomeServerInfo.fromJson(jsonBody);
    } else {
      printDebug('Request failed ${response.body}');
      throw response.body;
    }
  }
}
