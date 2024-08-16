import 'package:flutter/material.dart';
import 'package:home_dashboard/models/dashboard_widget_settings_row.dart';
import 'package:home_dashboard/utils/pad.dart';

class DashboardWidgetSettings {
  final List<DashboardWidgetSettingsRow> rows;
  final List<DashboardWidgetUptime>? uptimes;

  DashboardWidgetSettings(this.rows, {this.uptimes});

  factory DashboardWidgetSettings.fromJson(Map<String, dynamic> json) {
    List<DashboardWidgetUptime> uptimes = (json['uptimes'] as List<dynamic>?)
            ?.map((item) =>
                DashboardWidgetUptime.fromJson(item as Map<String, dynamic>))
            .toList() ??
        [];
    return DashboardWidgetSettings(
      (json['rows'] as List<dynamic>)
          .map((row) =>
              DashboardWidgetSettingsRow.fromJson(row as Map<String, dynamic>))
          .toList(),
      uptimes: uptimes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rows': rows.map((row) => row.toJson()).toList(),
      'uptimes': uptimes?.map((u) => u.toJson()).toList() ?? [],
    };
  }
}

class DashboardWidgetUptime {
  final TimeOfDay start;
  final TimeOfDay end;

  DashboardWidgetUptime(this.start, this.end);

  factory DashboardWidgetUptime.fromJson(Map<String, dynamic> json) {
    List<String> startString = json['start'].split(':');
    List<String> endString = json['end'].split(':');
    TimeOfDay start = TimeOfDay(
        hour: int.parse(startString[0]), minute: int.parse(startString[1]));
    TimeOfDay end = TimeOfDay(
        hour: int.parse(endString[0]), minute: int.parse(endString[1]));
    return DashboardWidgetUptime(start, end);
  }

  Map<String, dynamic> toJson() {
    return {
      'start': '${pad(start.hour, 2, '0')}:${pad(start.minute, 2, '0')}',
      'end': '${pad(end.hour, 2, '0')}:${pad(end.minute, 2, '0')}',
    };
  }
}
