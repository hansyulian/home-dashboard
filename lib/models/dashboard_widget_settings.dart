import 'package:home_dashboard/models/dashboard_widget_settings_row.dart';
import 'package:home_dashboard/models/time_window.dart';

class DashboardWidgetSettings {
  final List<DashboardWidgetSettingsRow> rows;
  final TimeWindow? uptime;

  DashboardWidgetSettings(this.rows, {this.uptime});

  factory DashboardWidgetSettings.fromJson(Map<String, dynamic> json) {
    TimeWindow? uptime =
        json['uptime'] ? TimeWindow.fromJson(json['uptime']) : null;
    return DashboardWidgetSettings(
      (json['rows'] as List<dynamic>)
          .map((row) =>
              DashboardWidgetSettingsRow.fromJson(row as Map<String, dynamic>))
          .toList(),
      uptime: uptime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rows': rows.map((row) => row.toJson()).toList(),
      'uptimes': uptime?.toJson(),
    };
  }
}
