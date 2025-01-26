import 'package:flutter/material.dart';
import 'package:home_dashboard/screens/dashboardScreen/dashboard_screen.dart';
import 'package:window_manager/window_manager.dart';
import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();
  await windowManager.ensureInitialized();
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.black,
      ),
      home: const DashboardScreen(),
    ),
  );
}
