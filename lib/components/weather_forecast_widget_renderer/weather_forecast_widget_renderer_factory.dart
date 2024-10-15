import 'package:flutter/material.dart';
import 'package:home_dashboard/components/weather_forecast_widget_renderer/weather_forecast_widget_compact_renderer.dart';
import 'package:home_dashboard/components/weather_forecast_widget_renderer/weather_forecast_widget_default_renderer.dart';
import 'package:home_dashboard/models/weather_forecast.dart';

class WeatherForecastWidgetRendererFactory extends StatelessWidget {
  final String variant;
  final List<WeatherForecast> data;

  const WeatherForecastWidgetRendererFactory(this.variant, this.data,
      {super.key});

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case 'compact':
        return WeatherForecastWidgetCompactRenderer(data);
      default:
        return WeatherForecastWidgetDefaultRenderer(data);
    }
  }
}
