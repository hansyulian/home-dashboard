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
  final double rainProbability;
  final double temperature;
  static ColorInterpolator temperatureColorInterpolator =
      ColorInterpolator(Config.coolColor, Config.hotColor);
  static ColorInterpolator rainColorInterpolator =
      ColorInterpolator(Config.lightRainColor, Config.heavyRainColor);

  WeatherForecast(this.type, this.dateTime, this.rainIntensity,
      this.temperature, this.rainProbability);

  Color get weatherColor {
    if (rainProbability == 0 && rainIntensity == 0) {
      return temperatureColor;
    }
    if (type == WeatherType.rainy) {
      return Config.heavyRainColor;
    }
    double ratio = valueRatio(
      rainProbability,
      0,
      100,
    );
    return temperatureColorInterpolator.interpolate(ratio);
  }

  Color get temperatureColor {
    double ratio = valueRatio(
      temperature,
      Config.coolTemperature,
      Config.hotTemperature,
    );
    return temperatureColorInterpolator.interpolate(ratio);
  }
}
