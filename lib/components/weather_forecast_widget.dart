import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:home_dashboard/models/weather_forecast.dart';
import 'package:home_dashboard/models/widget_setting.dart';
import 'package:home_dashboard/modules/color_interpolator.dart';
import 'package:home_dashboard/modules/tomorrow_io_driver.dart';
import 'package:home_dashboard/utils/pad.dart';
import 'package:home_dashboard/utils/value_ratio.dart';

class WeatherForecastWidget extends StatefulWidget {
  final WeatherForecastWidgetSetting setting;
  const WeatherForecastWidget(this.setting, {super.key});
  static const int itemPerColumn = 8;
  static const Color rainColor = Colors.blue;
  static const Color hotColor = Colors.orange;
  static const Color coolColor = Colors.teal;
  static const num coolTemperature = 16;
  static const num hotTemperature = 30;
  static const int totalColumn = 2;

  @override
  State<WeatherForecastWidget> createState() => WeatherForecastWidgetState();
}

class WeatherForecastWidgetState extends State<WeatherForecastWidget> {
  late Timer _timer;
  late TomorrowIODriver _driver;
  List<WeatherForecast> _data = [];
  final ColorInterpolator _colorInterpolator;

  WeatherForecastWidgetState()
      : _colorInterpolator = ColorInterpolator(
            WeatherForecastWidget.coolColor, WeatherForecastWidget.hotColor);

  @override
  void initState() {
    super.initState();
    _driver = TomorrowIODriver(
        widget.setting.apiKey, widget.setting.lat, widget.setting.lon);
    _startFetcher();
  }

  void _startFetcher() {
    _updateState();
    _timer = Timer.periodic(Duration(seconds: widget.setting.refreshInSecond),
        (timer) async {
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
    super.dispose();
    _timer.cancel();
  }

  List<WeatherForecast> _getColumnData(final int index) {
    int start = min(index * WeatherForecastWidget.itemPerColumn, _data.length);
    int end =
        min((index + 1) * WeatherForecastWidget.itemPerColumn, _data.length);
    return _data.sublist(start, end);
  }

  Color weatherColor(WeatherForecast data) {
    if (data.type == WeatherType.rainy) {
      return WeatherForecastWidget.rainColor;
    }
    double ratio = valueRatio(
      data.temperature,
      WeatherForecastWidget.coolTemperature,
      WeatherForecastWidget.hotTemperature,
    );
    return _colorInterpolator.interpolate(ratio);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < WeatherForecastWidget.totalColumn; i++) {
      if (i > 0) {
        children.add(const SizedBox(width: 8));
      }
      children.add(
          Expanded(flex: 1, child: renderWeatherReport(_getColumnData(i))));
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        children: children,
      ),
    );
  }

  Widget renderWeatherReport(List<WeatherForecast> data) {
    List<Widget> children = [];
    for (int i = 0; i < data.length; i++) {
      children.add(renderWeatherReportItem(data[i]));
      children.add(const SizedBox(height: 8));
    }
    return Column(children: children);
  }

  Widget renderWeatherReportItem(WeatherForecast data) {
    DateTime localDateTime = DateTime.parse(data.dateTime).toLocal();
    String timeLabel =
        '${pad(localDateTime.hour, 2, '0')}:${pad(localDateTime.minute, 2, '0')}';
    int temperatureLabel = data.temperature.round();
    String rainIntensityLabel = data.type == WeatherType.rainy
        ? '${(data.rainIntensity * 100).round()}'
        : '';
    return Expanded(
        flex: 1,
        child: Container(
            color: weatherColor(data),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(flex: 1, child: renderText(timeLabel)),
                Expanded(flex: 1, child: renderText('$temperatureLabel°C')),
                Expanded(flex: 1, child: renderWeatherIcon(data.type)),
                Expanded(flex: 1, child: renderText(rainIntensityLabel)),
              ],
            )));
  }

  Widget renderWeatherIcon(WeatherType type) {
    switch (type) {
      case WeatherType.rainy:
        return Image.asset('assets/icons/rain.png', height: 24, width: 24);
      default:
        return Container();
    }
  }

  Widget renderText(String text, {FontWeight? fontWeight}) {
    return Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          height: 1.0,
          decoration: TextDecoration.none,
          fontWeight: fontWeight ?? FontWeight.normal,
        ));
  }
}
