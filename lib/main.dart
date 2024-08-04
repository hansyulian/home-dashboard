import 'package:flutter/material.dart';
import 'package:home_dashboard/screens/dashboardScreen/dashboard_screen.dart';

import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();
  runApp(
    const MaterialApp(
      home: DashboardScreen(),
    ),
  );
}
