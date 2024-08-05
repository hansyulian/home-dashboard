import 'package:home_dashboard/models/dashboard_widget_settings_row.dart';

class DashboardWidgetSettings {
  final List<DashboardWidgetSettingsRow> rows;

  DashboardWidgetSettings(this.rows);

  factory DashboardWidgetSettings.fromJson(Map<String, dynamic> json) {
    return DashboardWidgetSettings(
      (json['rows'] as List<dynamic>)
          .map((row) =>
              DashboardWidgetSettingsRow.fromJson(row as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rows': rows.map((row) => row.toJson()).toList(),
    };
  }
}
