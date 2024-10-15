import 'dart:ui';

import 'package:home_dashboard/config/config.dart';
import 'package:home_dashboard/modules/color_interpolator.dart';
import 'package:home_dashboard/utils/value_ratio.dart';

enum WeatherType {
  clear,
  rainy,
}

class WeatherForecast {
  final WeatherType type;
  final String dateTime;
  final double rainIntensity;
  final double temperature;
  static ColorInterpolator colorInterpolator =
      ColorInterpolator(Config.coolColor, Config.hotColor);

  WeatherForecast(
    this.type,
    this.dateTime,
    this.rainIntensity,
    this.temperature,
  );

  Color get weatherColor {
    if (type == WeatherType.rainy) {
      return Config.rainColor;
    }
    double ratio = valueRatio(
      temperature,
      Config.coolTemperature,
      Config.hotTemperature,
    );
    return colorInterpolator.interpolate(ratio);
  }
}
