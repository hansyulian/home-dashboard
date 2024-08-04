import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_dashboard/models/dashboard_widget_settings.dart';
import 'package:home_dashboard/screens/dashboardScreen/dashboard_screen_layout.dart';
import 'package:home_dashboard/utils/debug_json.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? jsonData;
  DashboardWidgetSettings? dashboardWidgetSettings;

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/settings.json');
    final Map<String, dynamic> jsonData = json.decode(response);
    setState(() {
      this.jsonData = jsonData;
      dashboardWidgetSettings = DashboardWidgetSettings.fromJson(jsonData);
    });
  }

  Widget loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (dashboardWidgetSettings == null) {
      return loadingWidget();
    }

    debugJson(jsonData);
    return DashboardScreenLayout(dashboardWidgetSettings!);
  }
}
