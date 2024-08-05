import 'package:home_dashboard/models/dashboard_widget.dart';
import 'package:home_dashboard/utils/safe_parse_int.dart';

class DashboardWidgetSettingsColumn {
  final int? flex;
  final DashboardWidgetBase content;

  DashboardWidgetSettingsColumn(this.content, [this.flex]);

  factory DashboardWidgetSettingsColumn.fromJson(Map<String, dynamic> json) {
    var content = DashboardWidgetBase.fromJson(json['content']);
    var flex = safeParseInt(json['flex']);
    return DashboardWidgetSettingsColumn(content, flex);
  }

  Map<String, dynamic> toJson() {
    return {
      'flex': flex,
      'content': content.toJson(),
    };
  }
}
