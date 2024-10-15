import 'dart:math';

import 'package:flutter/material.dart';
import 'package:home_dashboard/config/config.dart';
import 'package:home_dashboard/models/weather_forecast.dart';
import 'package:home_dashboard/utils/pad.dart';

class WeatherForecastWidgetCompactRenderer extends StatelessWidget {
  final List<WeatherForecast> data;

  const WeatherForecastWidgetCompactRenderer(this.data, {super.key});

  List<WeatherForecast> _getColumnData(final int index) {
    int start = min(index * Config.itemPerColumn, data.length);
    int end = min((index + 1) * Config.itemPerColumn, data.length);
    return data.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < Config.totalColumn; i++) {
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
    String timeLabel = pad(localDateTime.hour, 2, '0');
    int temperatureLabel = data.temperature.round();
    String rainIntensityLabel = data.type == WeatherType.rainy
        ? '${(data.rainIntensity * 100).round()}'
        : '';
    var elementChildren = [
      Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(flex: 1, child: renderText(timeLabel, preset: 'small')),
              Expanded(flex: 1, child: renderText('$temperatureLabel°')),
            ],
          )),
    ];
    if (data.type == WeatherType.rainy) {
      elementChildren.add(Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.only(top: 4),
            child: renderText(
              rainIntensityLabel,
              preset: 'small',
            ),
          )));
    }
    return Expanded(
        flex: 1,
        child: Container(
            color: data.weatherColor,
            padding: const EdgeInsets.all(8),
            child: Column(children: elementChildren)));
  }

  Widget renderWeatherIcon(WeatherType type) {
    switch (type) {
      case WeatherType.rainy:
        return Image.asset('assets/icons/rain.png', height: 24, width: 24);
      default:
        return Container();
    }
  }

  Widget renderText(String text, {FontWeight? fontWeight, String? preset}) {
    return Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: preset == 'small' ? 16 : 24,
          height: 1.0,
          decoration: TextDecoration.none,
          fontWeight: fontWeight ?? FontWeight.normal,
        ));
  }
}
