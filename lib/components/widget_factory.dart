import 'package:flutter/material.dart';
import 'package:home_dashboard/components/cctv_widget.dart';
import 'package:home_dashboard/components/clock_widget.dart';
import 'package:home_dashboard/components/coin_tracker_widget.dart';
import 'package:home_dashboard/components/home_sensor_widget.dart';
import 'package:home_dashboard/components/home_server_info_widget.dart';
import 'package:home_dashboard/components/home_server_sensor_socket.dart';
import 'package:home_dashboard/components/weather_forecast_widget.dart';
import 'package:home_dashboard/models/widget_setting.dart';

class WidgetFactory extends StatelessWidget {
  final WidgetSetting spec;

  const WidgetFactory({super.key, required this.spec});

  Widget unimplemented() {
    return const Center(child: Text('Unimplemented'));
  }

  Widget blank() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    switch (spec.type) {
      case 'cctv':
        CctvWidgetSetting cctvWidget = spec as CctvWidgetSetting;
        return CctvWidget(cctvWidget);
      case 'clock':
        ClockWidgetSetting clockWidget = spec as ClockWidgetSetting;
        return ClockWidget(clockWidget);
      case 'coinTracker':
        CoinTrackerWidgetSetting coinTrackerWidget =
            spec as CoinTrackerWidgetSetting;
        return CoinTrackerWidget(coinTrackerWidget);
      case 'homeSensor':
        HomeSensorWidgetSetting waterTorrentWidget =
            spec as HomeSensorWidgetSetting;
        return HomeSensorWidget(waterTorrentWidget);
      case 'weatherForecast':
        WeatherForecastWidgetSetting weatherForecastWidgetSetting =
            spec as WeatherForecastWidgetSetting;
        return WeatherForecastWidget(weatherForecastWidgetSetting);
      case 'homeServerInfo':
        HomeServerInfoWidgetSetting homeServerInfoWidgetSetting =
            spec as HomeServerInfoWidgetSetting;
        return HomeServerInfoWidget(homeServerInfoWidgetSetting);
      case 'homeServerSensorSocket':
        HomeServerSensorSocketWidgetSetting
            homeServerSensorSocketWidgetSetting =
            spec as HomeServerSensorSocketWidgetSetting;
        return HomeServerSensorSocketWidget(
            homeServerSensorSocketWidgetSetting);
      case 'blank':
        return blank();
    }
    return unimplemented();
  }
}
