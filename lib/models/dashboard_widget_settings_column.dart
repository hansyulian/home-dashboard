import 'package:home_dashboard/models/widget_setting.dart';
import 'package:home_dashboard/utils/safe_parse_int.dart';

class DashboardWidgetSettingsColumn {
  final int? flex;
  final WidgetSetting content;

  DashboardWidgetSettingsColumn(this.content, [this.flex]);

  factory DashboardWidgetSettingsColumn.fromJson(Map<String, dynamic> json) {
    var content = WidgetSetting.fromJson(json['content']);
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
