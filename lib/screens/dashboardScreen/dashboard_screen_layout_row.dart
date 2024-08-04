import 'package:flutter/material.dart';
import 'package:home_dashboard/models/dashboard_widget_settings_row.dart';

class DashboardScreenLayoutRow extends StatelessWidget {
  final DashboardWidgetSettingsRow row;
  const DashboardScreenLayoutRow(this.row, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(),
      flex: row.flex ?? 1,
    );
  }
}
