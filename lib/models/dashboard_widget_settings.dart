import 'package:home_dashboard/models/dashboard_widget_settings_row.dart';
import 'package:home_dashboard/models/time_window.dart';

class DashboardWidgetSettings {
  final List<DashboardWidgetSettingsRow> rows;
  final TimeWindow? uptime;
  final bool? startFullscreen;
  final bool? manualClickUptime;

  DashboardWidgetSettings(this.rows,
      {this.uptime, this.startFullscreen, this.manualClickUptime});

  factory DashboardWidgetSettings.fromJson(Map<String, dynamic> json) {
    TimeWindow? uptime =
        json['uptime'] != null ? TimeWindow.fromJson(json['uptime']) : null;
    bool? startFullscreen = json['startFullscreen'];
    bool? manualClickUptime = json['manualClickUptime'];
    return DashboardWidgetSettings(
        (json['rows'] as List<dynamic>)
            .map((row) => DashboardWidgetSettingsRow.fromJson(
                row as Map<String, dynamic>))
            .toList(),
        uptime: uptime,
        manualClickUptime: manualClickUptime,
        startFullscreen: startFullscreen);
  }

  Map<String, dynamic> toJson() {
    return {
      'rows': rows.map((row) => row.toJson()).toList(),
      'uptimes': uptime?.toJson(),
      'startFullscreen': startFullscreen,
      'manualClickUptime': manualClickUptime,
    };
  }
}
