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
      case 'homeServerInfo':
        return HomeServerInfoWidgetSetting.fromJson(json);
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
  final List<String> coinSymbols;
  final int? _refreshInSecond;
  final double? _size;
  final String? _apiKey;
  final String? _driver;

  CoinTrackerWidgetSetting(this.coinSymbols,
      {int? refreshInSecond, double? size, String? apiKey, String? driver})
      : _refreshInSecond = refreshInSecond,
        _size = size,
        _apiKey = apiKey,
        _driver = driver;
  static int get defaultRefreshDuration => 60;

  @override
  String get type => 'coinTracker';
  String get driver => _driver ?? 'coinMarketCapWidget';

  double get size => _size ?? 1.0;

  int get refreshInSecond => _refreshInSecond ?? 60;

  String? get apiKey => _apiKey;

  factory CoinTrackerWidgetSetting.fromJson(Map<String, dynamic> json) {
    List<dynamic> coinSymbolsJson = json['coinSymbols'];
    List<String> coinSymbols = coinSymbolsJson.cast<String>();
    int? refreshInSecond = safeParseInt(json['refreshInSecond']);
    double? size = safeParseDouble(json['size']);
    String? apiKey = json['apiKey'];
    String? driver = json['driver'];
    return CoinTrackerWidgetSetting(
      coinSymbols,
      driver: driver ?? 'coinMarketCapWidget',
      apiKey: apiKey,
      refreshInSecond: refreshInSecond,
      size: size,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coins': coinSymbols,
      'refreshInSeconds': _refreshInSecond,
      'apiKey': _apiKey,
      'driver': _driver,
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

class WeatherForecastWidgetSetting extends WidgetSetting {
  final int? _refreshInSecond;
  final String apiKey;
  final double lat;
  final double lon;
  final bool mock;
  final String variant;
  static const defaultRefreshInSecond = 300;

  WeatherForecastWidgetSetting(this.apiKey, this.lat, this.lon, this.variant,
      {int? refreshInSecond, this.mock = false})
      : _refreshInSecond = refreshInSecond;

  int get refreshInSecond {
    if (_refreshInSecond == null) {
      return defaultRefreshInSecond;
    }
    if (_refreshInSecond < defaultRefreshInSecond) {
      return defaultRefreshInSecond;
    }
    return _refreshInSecond;
  }

  @override
  String get type => 'weatherForecast';

  factory WeatherForecastWidgetSetting.fromJson(Map<String, dynamic> json) {
    String apiKey = json['apiKey'];
    double lat = json['lat'];
    double lon = json['lon'];
    int? refreshInSecond = json['refreshInSecond'];
    bool mock = json['mock'] == true;
    String variant = json['variant'] ?? "default";

    return WeatherForecastWidgetSetting(apiKey, lat, lon, variant,
        refreshInSecond: refreshInSecond, mock: mock);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'refreshInSecond': _refreshInSecond,
      'apiKey': apiKey,
      'lat': lat,
      'lon': lon,
      'mock': mock,
    };
  }
}

class HomeServerInfoWidgetSetting extends WidgetSetting {
  final String apiEndpoint;
  final int? _refreshInSecond;

  HomeServerInfoWidgetSetting(this.apiEndpoint, {int? refreshInSecond})
      : _refreshInSecond = refreshInSecond;

  @override
  String get type => 'homeServerInfo';

  factory HomeServerInfoWidgetSetting.fromJson(Map<String, dynamic> json) {
    return HomeServerInfoWidgetSetting(json['apiEndpoint']);
  }
  int get refreshInSecond => _refreshInSecond ?? 1;

  @override
  Map<String, dynamic> toJson() {
    return {'type': type, 'apiEndpoint': apiEndpoint};
  }
}
