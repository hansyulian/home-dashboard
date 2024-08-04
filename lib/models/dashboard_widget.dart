abstract class DashboardWidgetBase {
  String get type;
  DashboardWidgetBase();

  factory DashboardWidgetBase.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'cctv':
        return CctvWidget.fromJson(json);
      case 'coinTracker':
        return CoinTrackerWidget.fromJson(json);
      case 'clock':
        return ClockWidget.fromJson(json);
      case 'weatherForecast':
        return WeatherForecastWidget.fromJson(json);
      default:
        throw ArgumentError('Unknown widget type');
    }
  }
}

// Concrete class for CctvWidget
class CctvWidget extends DashboardWidgetBase {
  final String streamUrl;

  CctvWidget(this.streamUrl);

  @override
  String get type => 'cctv';

  factory CctvWidget.fromJson(Map<String, dynamic> json) {
    return CctvWidget(json['streamUrl']);
  }
}

// Concrete class for CoinTrackerWidget
class CoinTrackerWidget extends DashboardWidgetBase {
  final List<String> coins;

  CoinTrackerWidget(this.coins);

  @override
  String get type => 'coinTracker';

  factory CoinTrackerWidget.fromJson(Map<String, dynamic> json) {
    return CoinTrackerWidget(json['coins']);
  }
}

// Concrete class for ClockWidget
class ClockWidget extends DashboardWidgetBase {
  ClockWidget();

  @override
  String get type => 'clock';

  factory ClockWidget.fromJson(Map<String, dynamic> json) {
    return ClockWidget();
  }
}

// Concrete class for WeatherForecastWidget
class WeatherForecastWidget extends DashboardWidgetBase {
  final String apiSource;

  WeatherForecastWidget(this.apiSource);

  @override
  String get type => 'weatherForecast';

  factory WeatherForecastWidget.fromJson(Map<String, dynamic> json) {
    return WeatherForecastWidget(json['apiSource']);
  }
}
