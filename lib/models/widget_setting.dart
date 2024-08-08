import 'package:home_dashboard/utils/safe_parse_double.dart';
import 'package:home_dashboard/utils/safe_parse_int.dart';

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
      case 'homeSensor':
        return HomeSensorWidgetSetting.fromJson(json);
      case 'blank':
        return BlankWidgetSetting.fromJson(json);
      default:
        return BlankWidgetSetting.fromJson(json);
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

class HomeSensorWidgetSetting extends WidgetSetting {
  final String apiEndpoint;
  final int? _refreshInSecond;

  HomeSensorWidgetSetting(this.apiEndpoint, {int? refreshInSecond})
      : _refreshInSecond = refreshInSecond;

  @override
  String get type => 'homeSensor';

  factory HomeSensorWidgetSetting.fromJson(Map<String, dynamic> json) {
    return HomeSensorWidgetSetting(json['apiEndpoint']);
  }
  int get refreshInSecond => _refreshInSecond ?? 60;

  @override
  Map<String, dynamic> toJson() {
    return {'type': type, 'apiEndpoint': apiEndpoint};
  }
}

// Concrete class for CoinTrackerWidget
class CoinTrackerWidgetSetting extends WidgetSetting {
  final List<String> coinIds;
  final int? _refreshInSecond;
  final double? _size;

  CoinTrackerWidgetSetting(this.coinIds, {int? refreshInSecond, double? size})
      : _refreshInSecond = refreshInSecond,
        _size = size;
  static int get defaultRefreshDuration => 60;

  @override
  String get type => 'coinTracker';

  double get size => _size ?? 1.0;

  int get refreshInSecond => _refreshInSecond ?? 60;

  factory CoinTrackerWidgetSetting.fromJson(Map<String, dynamic> json) {
    List<dynamic> coinIdsJson = json['coinIds'];
    List<String> coinIds = coinIdsJson.cast<String>();
    int? refreshInSecond = safeParseInt(json['refreshInSecond']);
    double? size = safeParseDouble(json['size']);
    return CoinTrackerWidgetSetting(
      coinIds,
      refreshInSecond: refreshInSecond,
      size: size,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coins': coinIds,
      'refreshInSeconds': _refreshInSecond
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
