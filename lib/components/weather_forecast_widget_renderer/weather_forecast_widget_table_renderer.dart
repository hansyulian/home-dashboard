import 'dart:math';

import 'package:flutter/material.dart';
import 'package:home_dashboard/config/config.dart';
import 'package:home_dashboard/models/weather_forecast.dart';
import 'package:home_dashboard/utils/pad.dart';

const baseSize = 24.0;
const headerSize = 28.0;

class WeatherForecastWidgetTableRenderer extends StatelessWidget {
  final List<WeatherForecast> data;

  const WeatherForecastWidgetTableRenderer(this.data, {super.key});

  TableRow renderTableHeader() {
    return TableRow(children: [
      WeatherTableHeader(text: 'Time', size: headerSize),
      WeatherTableHeader(text: '°C', size: headerSize),
      WeatherTableHeader(text: 'Rain', size: headerSize),
    ]);
  }

  List<WeatherForecast> get displayData =>
      data.sublist(0, min(12, data.length));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.black87,
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(4),
          },
          border: TableBorder.all(color: Colors.grey, width: 0.5),
          children: [
            renderTableHeader(),
            ...displayData.map((forecast) {
              DateTime localDateTime =
                  DateTime.parse(forecast.dateTime).toLocal();
              String timeLabel =
                  '${pad(localDateTime.hour, 2, '0')}:${pad(localDateTime.minute, 2, '0')}';
              int temperatureLabel = forecast.temperature.round();

              // rainIntensity is already multiplied by 1000 in the driver
              String rainValLabel = forecast.rainIntensity > 0
                  ? '(${forecast.rainIntensity})'
                  : '-';

              return TableRow(
                decoration: BoxDecoration(color: forecast.weatherColor),
                children: [
                  WeatherTableCell(
                    child: WeatherText(timeLabel, baseSize,
                        textAlign: TextAlign.center),
                  ),
                  WeatherTableCell(
                    child: WeatherText('$temperatureLabel', baseSize,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.bold),
                  ),
                  WeatherTableCell(
                    child: WeatherText(
                      '${forecast.rainProbability.round()}% $rainValLabel',
                      baseSize,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget renderWeatherIcon(WeatherType type) {
    switch (type) {
      case WeatherType.rainy:
        return Image.asset('assets/icons/rain.png',
            height: baseSize, width: baseSize);
      default:
        return SizedBox(width: baseSize, height: baseSize);
    }
  }
}

class WeatherTableHeaderText extends StatelessWidget {
  final String text;
  final double size;

  const WeatherTableHeaderText(this.text, this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return WeatherText(text, size,
        fontWeight: FontWeight.bold, textAlign: TextAlign.center);
  }
}

class WeatherText extends StatelessWidget {
  final String text;
  final double size;
  final Color? _color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;

  const WeatherText(this.text, this.size,
      {super.key, Color? color, this.textAlign, this.fontWeight})
      : _color = color;

  Color get color {
    if (_color != null) {
      return _color;
    }
    return const Color(0xEEEEEEFF);
  }

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        style: TextStyle(
            color: color,
            fontSize: size,
            height: 1.0,
            decoration: TextDecoration.none,
            fontWeight: fontWeight ?? FontWeight.normal));
  }
}

class WeatherTableHeader extends StatelessWidget {
  final String text;
  final double size;

  const WeatherTableHeader({
    required this.text,
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: WeatherTableHeaderText(text, size),
      ),
    );
  }
}

class WeatherTableCell extends StatelessWidget {
  final Widget child;

  const WeatherTableCell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
