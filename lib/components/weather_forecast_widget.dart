import 'dart:async';

import 'package:flutter/material.dart';
import 'package:home_dashboard/components/weather_forecast_widget_renderer/weather_forecast_widget_renderer_factory.dart';
import 'package:home_dashboard/models/weather_forecast.dart';
import 'package:home_dashboard/models/widget_setting.dart';
import 'package:home_dashboard/modules/tomorrow_io_driver.dart';

class WeatherForecastWidget extends StatefulWidget {
  final WeatherForecastWidgetSetting setting;
  const WeatherForecastWidget(this.setting, {super.key});

  @override
  State<WeatherForecastWidget> createState() => WeatherForecastWidgetState();
}

class WeatherForecastWidgetState extends State<WeatherForecastWidget> {
  late Timer _timer;
  late TomorrowIODriver _driver;
  List<WeatherForecast> _data = [];
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    _driver = TomorrowIODriver(
        widget.setting.apiKey, widget.setting.lat, widget.setting.lon,
        mock: widget.setting.mock);
    setState(() {
      _isTimerRunning = false;
    });
    _startFetcher();
  }

  void _startFetcher() {
    setState(() {
      _isTimerRunning = true;
    });
    _updateState();
    _timer = Timer.periodic(Duration(seconds: widget.setting.refreshInSecond),
        (timer) async {
      if (!_isTimerRunning) {
        return;
      }
      _updateState();
    });
  }

  void _updateState() async {
    var responseData = await _driver.safeFetch();
    setState(() {
      _data = responseData;
    });
  }

  @override
  void dispose() {
    setState(() {
      _isTimerRunning = false;
    });
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WeatherForecastWidgetRendererFactory(widget.setting.variant, _data);
  }
}
