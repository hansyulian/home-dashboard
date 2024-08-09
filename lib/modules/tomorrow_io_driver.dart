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

  TomorrowIODriver(this.apiKey, this.lat, this.lon);

  Future<List<WeatherForecast>> safeFetch() async {
    final uri = Uri.parse('https://api.tomorrow.io/v4/timelines');
    // final response = await http.post(
    //   uri,
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'Accept': 'application/json',
    //     'apikey': apiKey,
    //   },
    //   body: jsonEncode({
    //     'location': '$lat,$lon',
    //     'timesteps': ['1h'],
    //     'units': 'metric',
    //     'fields': ['temperature', 'rainIntensity', 'weatherCode'],
    //   }),
    // );

    // if (response.statusCode == 200) {
    //   final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final Map<String, dynamic> jsonData = {
      "data": {
        "timelines": [
          {
            "timestep": "1h",
            "endTime": "2024-08-14T08:00:00Z",
            "startTime": "2024-08-09T08:00:00Z",
            "intervals": [
              {
                "startTime": "2024-08-09T08:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 31.13,
                  "weatherCode": 1101
                }
              },
              {
                "startTime": "2024-08-09T09:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 28.84,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-09T10:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 26.86,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-09T11:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 23.95,
                  "weatherCode": 1101
                }
              },
              {
                "startTime": "2024-08-09T12:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 23.34,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-09T13:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 21.84,
                  "weatherCode": 1000
                }
              },
              {
                "startTime": "2024-08-09T14:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 20.79,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-09T15:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 20.1,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-09T16:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 19.25,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-09T17:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.91,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-09T18:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.84,
                  "weatherCode": 1102
                }
              },
              {
                "startTime": "2024-08-09T19:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.83,
                  "weatherCode": 1102
                }
              },
              {
                "startTime": "2024-08-09T20:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.23,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-09T21:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 17.91,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-09T22:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 17.84,
                  "weatherCode": 1000
                }
              },
              {
                "startTime": "2024-08-09T23:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 17.71,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-10T00:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 19.56,
                  "weatherCode": 1000
                }
              },
              {
                "startTime": "2024-08-10T01:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 21.91,
                  "weatherCode": 1000
                }
              },
              {
                "startTime": "2024-08-10T02:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 24.06,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-10T03:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 25.58,
                  "weatherCode": 1000
                }
              },
              {
                "startTime": "2024-08-10T04:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 26.9,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-10T05:00:00Z",
                "values": {
                  "rainIntensity": 0.16,
                  "temperature": 28,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-10T06:00:00Z",
                "values": {
                  "rainIntensity": 0.16,
                  "temperature": 28.29,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-10T07:00:00Z",
                "values": {
                  "rainIntensity": 0.26,
                  "temperature": 28.13,
                  "weatherCode": 4000
                }
              },
              {
                "startTime": "2024-08-10T08:00:00Z",
                "values": {
                  "rainIntensity": 0.26,
                  "temperature": 27.37,
                  "weatherCode": 4000
                }
              },
              {
                "startTime": "2024-08-10T09:00:00Z",
                "values": {
                  "rainIntensity": 0.05,
                  "temperature": 26.52,
                  "weatherCode": 1102
                }
              },
              {
                "startTime": "2024-08-10T10:00:00Z",
                "values": {
                  "rainIntensity": 0.3,
                  "temperature": 25.28,
                  "weatherCode": 4000
                }
              },
              {
                "startTime": "2024-08-10T11:00:00Z",
                "values": {
                  "rainIntensity": 0.07,
                  "temperature": 23.39,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-10T12:00:00Z",
                "values": {
                  "rainIntensity": 0.01,
                  "temperature": 21.83,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-10T13:00:00Z",
                "values": {
                  "rainIntensity": 0.06,
                  "temperature": 20.97,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-10T14:00:00Z",
                "values": {
                  "rainIntensity": 0.01,
                  "temperature": 20.35,
                  "weatherCode": 1101
                }
              },
              {
                "startTime": "2024-08-10T15:00:00Z",
                "values": {
                  "rainIntensity": 0.05,
                  "temperature": 20.69,
                  "weatherCode": 1101
                }
              },
              {
                "startTime": "2024-08-10T16:00:00Z",
                "values": {
                  "rainIntensity": 0.03,
                  "temperature": 20.73,
                  "weatherCode": 1101
                }
              },
              {
                "startTime": "2024-08-10T17:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 20.52,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-10T18:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 19.77,
                  "weatherCode": 2100
                }
              },
              {
                "startTime": "2024-08-10T19:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.86,
                  "weatherCode": 2000
                }
              },
              {
                "startTime": "2024-08-10T20:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.01,
                  "weatherCode": 2100
                }
              },
              {
                "startTime": "2024-08-10T21:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 17.29,
                  "weatherCode": 2100
                }
              },
              {
                "startTime": "2024-08-10T22:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 16.8,
                  "weatherCode": 1000
                }
              },
              {
                "startTime": "2024-08-10T23:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 16.27,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-11T00:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.07,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-11T01:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 20.5,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-11T02:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 23.21,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-11T03:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 25.38,
                  "weatherCode": 1000
                }
              },
              {
                "startTime": "2024-08-11T04:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 26.81,
                  "weatherCode": 1000
                }
              },
              {
                "startTime": "2024-08-11T05:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 27.84,
                  "weatherCode": 1000
                }
              },
              {
                "startTime": "2024-08-11T06:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 28.35,
                  "weatherCode": 1000
                }
              },
              {
                "startTime": "2024-08-11T07:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 28.46,
                  "weatherCode": 1000
                }
              },
              {
                "startTime": "2024-08-11T08:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 27.85,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-11T09:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 26.77,
                  "weatherCode": 1101
                }
              },
              {
                "startTime": "2024-08-11T10:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 24.73,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-11T11:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 22.56,
                  "weatherCode": 1000
                }
              },
              {
                "startTime": "2024-08-11T12:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 20.83,
                  "weatherCode": 1000
                }
              },
              {
                "startTime": "2024-08-11T13:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 19.89,
                  "weatherCode": 1000
                }
              },
              {
                "startTime": "2024-08-11T14:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.94,
                  "weatherCode": 1102
                }
              },
              {
                "startTime": "2024-08-11T15:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.56,
                  "weatherCode": 1101
                }
              },
              {
                "startTime": "2024-08-11T16:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.07,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-11T17:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 17.6,
                  "weatherCode": 1101
                }
              },
              {
                "startTime": "2024-08-11T18:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 16.79,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-11T19:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 16.85,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-11T20:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 16.6,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-11T21:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 16.18,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-11T22:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 16.22,
                  "weatherCode": 1101
                }
              },
              {
                "startTime": "2024-08-11T23:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 15.21,
                  "weatherCode": 1101
                }
              },
              {
                "startTime": "2024-08-12T00:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 17.06,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-12T01:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 19.15,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-12T02:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 21.72,
                  "weatherCode": 1000
                }
              },
              {
                "startTime": "2024-08-12T03:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 23.98,
                  "weatherCode": 1000
                }
              },
              {
                "startTime": "2024-08-12T04:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 25.72,
                  "weatherCode": 1000
                }
              },
              {
                "startTime": "2024-08-12T05:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 27.01,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-12T06:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 27.59,
                  "weatherCode": 1102
                }
              },
              {
                "startTime": "2024-08-12T07:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 27.63,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-12T08:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 26.65,
                  "weatherCode": 1101
                }
              },
              {
                "startTime": "2024-08-12T09:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 26.47,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-12T10:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 25.18,
                  "weatherCode": 1100
                }
              },
              {
                "startTime": "2024-08-12T11:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 23.22,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-12T12:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 21.01,
                  "weatherCode": 1101
                }
              },
              {
                "startTime": "2024-08-12T13:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 19.39,
                  "weatherCode": 1102
                }
              },
              {
                "startTime": "2024-08-12T14:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.63,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-12T15:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.58,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-12T16:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.12,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-12T17:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 17.76,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-12T18:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 17.58,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-12T19:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 17.44,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-12T20:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 17.17,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-12T21:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 16.94,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-12T22:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 16.77,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-12T23:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 16.56,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T00:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.25,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T01:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 20.98,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T02:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 23.5,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T03:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 25.69,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T04:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 27.69,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T05:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 28.83,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T06:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 29.28,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T07:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 29.4,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T08:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 28.85,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T09:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 27.39,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T10:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 25.19,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T11:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 22.79,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T12:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 22.02,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T13:00:00Z",
                "values": {
                  "rainIntensity": 0.03,
                  "temperature": 21.55,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T14:00:00Z",
                "values": {
                  "rainIntensity": 0.02,
                  "temperature": 20.2,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T15:00:00Z",
                "values": {
                  "rainIntensity": 0.01,
                  "temperature": 19.83,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T16:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 19.33,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T17:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.89,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T18:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.57,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T19:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.2,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T20:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 17.9,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T21:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 17.52,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T22:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 17.23,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-13T23:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 17.05,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-14T00:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 18.67,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-14T01:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 21.15,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-14T02:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 23.62,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-14T03:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 26.1,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-14T04:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 27.18,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-14T05:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 28.26,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-14T06:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 29.34,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-14T07:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 28.72,
                  "weatherCode": 1001
                }
              },
              {
                "startTime": "2024-08-14T08:00:00Z",
                "values": {
                  "rainIntensity": 0,
                  "temperature": 28.1,
                  "weatherCode": 1001
                }
              }
            ]
          }
        ]
      }
    };
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
    // }
    return [];
  }
}
