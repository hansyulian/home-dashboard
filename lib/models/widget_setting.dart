import 'package:home_dashboard/utils/safe_parse_double.dart';

abstract class WidgetSetting {
  String get type;
  WidgetSetting();

  factory WidgetSetting.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'cctv':
        return CctvWidgetSetting.fromJson(json);
      case 'coinTracker':
        return CoinTrackerWidgetSetting.fromJson(json);
      case 'clock':
        return ClockWidgetSetting.fromJson(json);
      case 'weatherForecast':
        return WeatherForecastWidgetSetting.fromJson(json);
      case 'blank':
        return BlankWidgetSetting.fromJson(json);
      default:
        throw ArgumentError('Unknown widget type');
    }
  }

  Map<String, dynamic> toJson();
}

// Concrete class for Blank Widget
class BlankWidgetSetting extends WidgetSetting {
  @override
  String get type => 'blank';

  BlankWidgetSetting();

  factory BlankWidgetSetting.fromJson(Map<String, dynamic> json) {
    return BlankWidgetSetting();
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': type};
  }
}

// Concrete class for CctvWidget
class CctvWidgetSetting extends WidgetSetting {
  final String streamUrl;

  CctvWidgetSetting(this.streamUrl);

  @override
  String get type => 'cctv';

  factory CctvWidgetSetting.fromJson(Map<String, dynamic> json) {
    return CctvWidgetSetting(json['streamUrl']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': type, 'streamUrl': streamUrl};
  }
}

// Concrete class for CoinTrackerWidget
class CoinTrackerWidgetSetting extends WidgetSetting {
  final List<String> coins;

  CoinTrackerWidgetSetting(this.coins);

  @override
  String get type => 'coinTracker';

  factory CoinTrackerWidgetSetting.fromJson(Map<String, dynamic> json) {
    return CoinTrackerWidgetSetting(json['coins']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coins': coins,
    };
  }
}

// Concrete class for ClockWidget
class ClockWidgetSetting extends WidgetSetting {
  final double? size;
  ClockWidgetSetting({this.size});

  @override
  String get type => 'clock';

  factory ClockWidgetSetting.fromJson(Map<String, dynamic> json) {
    double? size = safeParseDouble(json['size']);
    return ClockWidgetSetting(size: size);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'size': size,
    };
  }
}

// Concrete class for WeatherForecastWidget
class WeatherForecastWidgetSetting extends WidgetSetting {
  final String apiSource;

  WeatherForecastWidgetSetting(this.apiSource);

  @override
  String get type => 'weatherForecast';

  factory WeatherForecastWidgetSetting.fromJson(Map<String, dynamic> json) {
    return WeatherForecastWidgetSetting(json['apiSource']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'apiSource': apiSource,
    };
  }
}
