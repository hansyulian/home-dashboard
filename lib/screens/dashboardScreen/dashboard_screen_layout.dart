import 'package:flutter/material.dart';
import 'package:home_dashboard/models/dashboard_widget_settings.dart';
import 'package:home_dashboard/screens/dashboardScreen/dashboard_screen_layout_row.dart';

class DashboardScreenLayout extends StatelessWidget {
  final DashboardWidgetSettings settings;
  const DashboardScreenLayout(this.settings, {super.key});
  @override
  Widget build(BuildContext context) {
    var rows = settings.rows;
    return Column(
      children: rows.map((row) => DashboardScreenLayoutRow(row)).toList(),
    );
  }
}
