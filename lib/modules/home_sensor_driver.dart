import 'dart:convert';

import 'package:home_dashboard/models/home_sensor.dart';
import 'package:home_dashboard/utils/print_debug.dart';
import 'package:http/http.dart' as http;

class HomeSensorResponse {
  WaterTorrentHomeSensor? waterTorrent;

  HomeSensorResponse({this.waterTorrent});
}

class HomeSensorDriver {
  final String apiEndpoint;

  HomeSensorDriver(this.apiEndpoint);

  Future<HomeSensorResponse> safeRetrieve() async {
    final HomeSensorResponse result = HomeSensorResponse();
    try {
      final url = Uri.parse(apiEndpoint);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        result.waterTorrent =
            WaterTorrentHomeSensor.fromJson(jsonBody['waterTorrent']);
        return result;
      } else {
        printDebug('Request failed ${response.body}');
        return result;
      }
    } catch (err) {
      printDebug('Request error $err');
      return result;
    }
  }
}
