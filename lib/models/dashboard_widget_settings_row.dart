import 'package:home_dashboard/models/dashboard_widget_settings_column.dart';
import 'package:home_dashboard/utils/safe_parse_int.dart';

class DashboardWidgetSettingsRow {
  final List<DashboardWidgetSettingsColumn> columns;
  final int? flex;

  DashboardWidgetSettingsRow(this.columns, [this.flex]);

  factory DashboardWidgetSettingsRow.fromJson(Map<String, dynamic> json) {
    var columns = (json['columns'] as List<dynamic>)
        .map((column) => DashboardWidgetSettingsColumn.fromJson(column))
        .toList();
    var flex = safeParseInt(json['flex']);
    return DashboardWidgetSettingsRow(columns, flex);
  }

  Map<String, dynamic> toJson() {
    return {
      'flex': flex,
      'columns': columns.map((column) => column.toJson()).toList(),
    };
  }
}
