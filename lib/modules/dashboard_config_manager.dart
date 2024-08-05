import 'dart:convert';
import 'dart:io';
import 'package:home_dashboard/models/dashboard_widget_settings.dart';
import 'package:home_dashboard/models/dashboard_widget_settings_row.dart';
import 'package:home_dashboard/utils/print_debug.dart';
import 'package:path_provider/path_provider.dart';

var defaultConfig = DashboardWidgetSettings([DashboardWidgetSettingsRow([])]);
const appName = 'HansHomeDashboard';

class DashboardConfigManager {
  // Private constructor
  static Future<DashboardWidgetSettings> dashboardWidgetSettings = readConfig();
  DashboardConfigManager._privateConstructor();

  // Single instance of ConfigManager
  static final DashboardConfigManager _instance =
      DashboardConfigManager._privateConstructor();

  // Factory constructor to return the single instance
  factory DashboardConfigManager() {
    return _instance;
  }

  static Future<String> getDocumentsDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> getConfigFile() async {
    final documentPath = await getDocumentsDirectoryPath();
    final appDirectoryPath = '$documentPath/$appName';
    final directory = Directory(appDirectoryPath);
    if (!await directory.exists()) {
      try {
        await directory.create(recursive: true);
        printDebug('Directory created successfully.');
      } catch (e) {
        printDebug('Error creating directory: $e');
      }
    }
    final filePath = '$appDirectoryPath/config.json';
    printDebug(filePath);
    return File(filePath);
  }

  static Future<DashboardWidgetSettings> readConfig() async {
    try {
      final file = await getConfigFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        var jsonObject = jsonDecode(contents);
        return DashboardWidgetSettings.fromJson(jsonObject);
      } else {
        await writeConfig(defaultConfig);
        return defaultConfig;
      }
    } catch (e) {
      printDebug('Error reading config file: $e');
      return defaultConfig;
    }
  }

  static Future<void> writeConfig(DashboardWidgetSettings config) async {
    try {
      final file = await getConfigFile();
      final contents = jsonEncode(config.toJson());
      await file.writeAsString(contents);
    } catch (e) {
      printDebug('Error writing to config file: $e');
    }
  }
}
