import 'dart:convert';
import 'package:home_dashboard/models/weather_forecast.dart';
import 'package:home_dashboard/utils/safe_parse_double.dart';
import 'package:http/http.dart' as http;

class HttpRequest {
  static Future<http.Response> request({
    required String url,
    required String method,
    Map<String, String>? params,
    Map<String, dynamic>? data,
  }) async {
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'apikey': params?['apikey'] ?? '',
      },
      body: jsonEncode(data),
    );
    return response;
  }
}

class TomorrowIODriver {
  final String apiKey;
  final double lat;
  final double lon;
  final bool mock;

  TomorrowIODriver(this.apiKey, this.lat, this.lon, {this.mock = false});

  Future<List<WeatherForecast>> safeFetch() async {
    if (mock) {
      return safeFetchMock();
    }
    final uri = Uri.parse('https://api.tomorrow.io/v4/timelines');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'apikey': apiKey,
      },
      body: jsonEncode({
        'location': '$lat,$lon',
        'timesteps': ['1h'],
        'units': 'metric',
        'fields': ['temperature', 'rainIntensity', 'weatherCode'],
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> intervals = jsonData['data']['timelines'][0]['intervals'];
      List<WeatherForecast> result = [];
      for (var i = 0; i < intervals.length; i++) {
        var interval = intervals[i];
        dynamic values = interval['values'];
        String time = interval['startTime'];
        double rainIntensity = safeParseDouble(values['rainIntensity']) ?? 0;
        double temperature = safeParseDouble(values['temperature']) ?? 0;
        int weatherCode = values['weatherCode'];
        WeatherType type =
            '$weatherCode'[0] == '4' ? WeatherType.rainy : WeatherType.clear;
        result.add(WeatherForecast(type, time, rainIntensity, temperature));
      }
      return result;
    }
    return [];
  }

  Future<List<WeatherForecast>> safeFetchMock() async {
    List<WeatherForecast> result = [];
    var now = DateTime.now();
    for (var i = 0; i < 30; i++) {
      double temperature = 15.0 + (12 - i).abs();
      var weatherType =
          temperature < 20 ? WeatherType.rainy : WeatherType.clear;
      var hour = now.hour + i;
      var day = hour > 24 ? now.day + 1 : now.day;
      var dateTime = DateTime(now.year, now.month, day, hour % 24, 0, 0);
      double rainIntensity =
          weatherType == WeatherType.rainy ? 10 - (i * 0.1) : 0;
      result.add(WeatherForecast(
          weatherType, dateTime.toString(), rainIntensity, temperature));
    }
    return result;
  }
}
