import 'package:flutter/material.dart';
import 'package:home_dashboard/models/dashboard_widget_settings_row.dart';
import 'package:home_dashboard/screens/dashboardScreen/dashboard_screen_layout_column.dart';

class DashboardScreenLayoutRow extends StatelessWidget {
  final DashboardWidgetSettingsRow row;
  const DashboardScreenLayoutRow(this.row, {super.key});

  @override
  Widget build(BuildContext context) {
    var flex = row.flex ?? 1;
    return Expanded(
      flex: flex,
      child: Row(
          children: row.columns
              .map((column) => DashboardScreenLayoutColumn(column))
              .toList()),
    );
  }
}
