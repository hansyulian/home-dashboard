import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_dashboard/models/dashboard_widget_settings.dart';
import 'package:home_dashboard/modules/dashboard_config_manager.dart';
import 'package:home_dashboard/screens/dashboardScreen/dashboard_screen_layout.dart';
import 'package:home_dashboard/utils/debug_json.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  DashboardWidgetSettings? dashboardWidgetSettings;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initialize() async {
    var dashboardConfig = await DashboardConfigManager.dashboardWidgetSettings;
    debugJson(dashboardConfig.toJson());
    setState(() {
      dashboardWidgetSettings = dashboardConfig;
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
    return DashboardScreenLayout(dashboardWidgetSettings!);
  }
}
