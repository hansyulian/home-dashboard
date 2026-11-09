import 'dart:convert';
import 'package:home_dashboard/models/weather_forecast.dart';
import 'package:home_dashboard/utils/safe_parse_double.dart';
import 'package:http/http.dart' as http;

class OpenMeteoDriver {
  final double lat;
  final double lon;
  final bool mock;

  OpenMeteoDriver(this.lat, this.lon, {this.mock = false});

  Future<List<WeatherForecast>> safeFetch() async {
    if (mock) {
      return safeFetchMock();
    }

    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$lat&longitude=$lon'
      '&hourly=temperature_2m,precipitation_probability,precipitation,weather_code'
      '&timezone=auto',
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final Map<String, dynamic> hourly = jsonData['hourly'];

        List<dynamic> times = hourly['time'];
        List<dynamic> temperatures = hourly['temperature_2m'];
        List<dynamic> rainProbs = hourly['precipitation_probability'];
        List<dynamic> precipitations = hourly['precipitation'];
        List<dynamic> weatherCodes = hourly['weather_code'];

        List<WeatherForecast> result = [];
        for (var i = 0; i < times.length; i++) {
          String time = times[i];
          double temperature = safeParseDouble(temperatures[i]) ?? 0.0;
          double rainProbability = safeParseDouble(rainProbs[i]) ?? 0.0;

          // Multiply precipitation by 1000 as requested
          double rainIntensity =
              (safeParseDouble(precipitations[i]) ?? 0.0) * 1000;

          int weatherCode = weatherCodes[i] is int
              ? weatherCodes[i]
              : int.tryParse('${weatherCodes[i]}') ?? 0;

          // WMO Weather Codes for rain, showers, and thunderstorms
          bool isRainy = [51, 53, 55, 61, 63, 65, 80, 81, 82, 95, 96, 99]
                  .contains(weatherCode) ||
              rainIntensity > 0;

          WeatherType type = isRainy ? WeatherType.rainy : WeatherType.clear;

          result.add(WeatherForecast(
            type,
            time,
            rainIntensity,
            temperature,
            rainProbability,
          ));
        }
        return result;
      }
    } catch (e) {
      // Handle network or parsing exceptions as needed
    }
    return [];
  }

  Future<List<WeatherForecast>> safeFetchMock() async {
    List<WeatherForecast> result = [];
    var now = DateTime.now();
    for (var i = 0; i < 24; i++) {
      double temperature = 22.0 + (5 - (i % 8));
      var weatherType = (i % 4 == 0) ? WeatherType.rainy : WeatherType.clear;
      var hour = now.hour + i;
      var day = hour >= 24 ? now.day + (hour ~/ 24) : now.day;
      var dateTime =
          DateTime(now.year, now.month, day, hour % 24, 0, 0).toIso8601String();

      double rainIntensity =
          weatherType == WeatherType.rainy ? 1.2 * 1000 : 0.0;
      double rainProbability = weatherType == WeatherType.rainy ? 85.0 : 0.0;

      result.add(WeatherForecast(
        weatherType,
        dateTime,
        rainIntensity,
        temperature,
        rainProbability,
      ));
    }
    return result;
  }
}
