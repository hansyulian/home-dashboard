import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_dashboard/models/dashboard_widget_settings.dart';
import 'package:home_dashboard/modules/dashboard_config_manager.dart';
import 'package:home_dashboard/screens/dashboardScreen/dashboard_screen_layout.dart';
import 'package:home_dashboard/utils/debug_json.dart';
import 'package:home_dashboard/utils/get_next_time_of_day.dart';
import 'package:home_dashboard/utils/is_in_time_window.dart';
import 'package:home_dashboard/utils/print_debug.dart';

const waitOffset = 10;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  DashboardWidgetSettings? dashboardWidgetSettings;
  bool _isActive = true;
  late Timer _activeTimer;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _activeTimer.cancel();
  }

  Future<void> initialize() async {
    var dashboardConfig = await DashboardConfigManager.dashboardWidgetSettings;
    debugJson(dashboardConfig.toJson());
    setState(() {
      dashboardWidgetSettings = dashboardConfig;
    });
    _startTimer();
  }

  void _startTimer() {
    if (dashboardWidgetSettings?.uptime == null) {
      return;
    }
    DateTime now = DateTime.now();
    bool inTimeWindow = isInTimeWindow(now, dashboardWidgetSettings!.uptime!);
    _isActive = inTimeWindow;
    printDebug('isActive $_isActive');
    DateTime nextAction = getNextTimeOfDay(inTimeWindow
        ? dashboardWidgetSettings!.uptime!.end
        : dashboardWidgetSettings!.uptime!.start);
    int waitSeconds =
        nextAction.difference(now).inSeconds + waitOffset; // 10 seconds spare
    printDebug('Waiting for $waitSeconds seconds to the next state check');

    _activeTimer = Timer(Duration(seconds: waitSeconds), () {
      _startTimer();
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
