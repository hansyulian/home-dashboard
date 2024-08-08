import 'package:flutter/material.dart';
import 'package:home_dashboard/components/widget_factory.dart';
import 'package:home_dashboard/models/dashboard_widget_settings_column.dart';

class DashboardScreenLayoutColumn extends StatelessWidget {
  final DashboardWidgetSettingsColumn column;
  const DashboardScreenLayoutColumn(this.column, {super.key});

  @override
  Widget build(BuildContext context) {
    var flex = column.flex ?? 1;
    return Expanded(flex: flex, child: WidgetFactory(spec: column.content));
  }
}
