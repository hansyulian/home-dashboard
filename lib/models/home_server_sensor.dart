import 'package:flutter/material.dart';
import 'package:home_dashboard/utils/safe_parse_double.dart';
import 'package:home_dashboard/utils/safe_parse_int.dart';

class HomeServerSensor {
  final HomeServerSystemInfo system;
  final List<HomeServerHddInfo> hdds;
  final List<HomeServerPingInfo> pings;

  HomeServerSensor({
    required this.system,
    required this.hdds,
    required this.pings,
  });

  factory HomeServerSensor.fromJson(Map<String, dynamic> json) {
    // Corrected to match the provided JSON structure's keys
    var systemJson = json['systemStatus'];
    var system = HomeServerSystemInfo.fromJson(systemJson);

    var hddsJson = json['hdd'] as List<dynamic>;
    List<HomeServerHddInfo> hdds =
        hddsJson.map((hddJson) => HomeServerHddInfo.fromJson(hddJson)).toList();

    var pingsJson = (json['ping'] ?? []) as List<dynamic>;
    List<HomeServerPingInfo> pings = pingsJson
        .map((pingJson) => HomeServerPingInfo.fromJson(pingJson))
        .toList();

    return HomeServerSensor(system: system, hdds: hdds, pings: pings);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'systemStatus': system.toJson(), // Output key matches input key
      'hdd': hdds.map((hdd) => hdd.toJson()).toList(),
      'ping': pings.map((ping) => ping.toJson()).toList(),
    };
  }
}

class HomeServerHddInfo {
  final String name;
  final String status;

  HomeServerHddInfo({
    required this.name,
    required this.status,
  });

  factory HomeServerHddInfo.fromJson(Map<String, dynamic> json) {
    return HomeServerHddInfo(
      name: json['name'] as String,
      status: json['status'] as String,
    );
  }

  Color get indicatorColor {
    switch (status) {
      case 'standby':
        return Colors.green;
      case 'active':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'status': status,
    };
  }
}

class HomeServerPingInfo {
  final String target;
  final double? lastValue; // Changed 'result' to 'lastValue' to match JSON

  HomeServerPingInfo({
    required this.target,
    this.lastValue, // Made nullable to reflect the JSON example's 0 value
  });

  factory HomeServerPingInfo.fromJson(Map<String, dynamic> json) {
    // Corrected to match the provided JSON structure's keys
    double? parsedLastValue = safeParseDouble(json['lastValue']);

    return HomeServerPingInfo(
      target: json['target'] as String,
      lastValue: parsedLastValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'target': target,
      'lastValue': lastValue,
    };
  }
}

class HomeServerSystemInfo {
  final HomeServerSystemCpuInfo cpu;
  final HomeServerSystemNetworkInfo network;
  final HomeServerSystemMemoryInfo memory;

  HomeServerSystemInfo({
    required this.cpu,
    required this.network,
    required this.memory,
  });

  factory HomeServerSystemInfo.fromJson(Map<String, dynamic> json) {
    return HomeServerSystemInfo(
      cpu:
          HomeServerSystemCpuInfo.fromJson(json['cpu'] as Map<String, dynamic>),
      network: HomeServerSystemNetworkInfo.fromJson(
          json['network'] as Map<String, dynamic>),
      memory: HomeServerSystemMemoryInfo.fromJson(
          json['memory'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpu': cpu.toJson(),
      'network': network.toJson(),
      'memory': memory.toJson(),
    };
  }
}

class HomeServerSystemCpuInfo {
  final double? total; // Changed 'usage' to 'total' to match JSON
  final int? idle; // Added 'idle' to match JSON
  final double? temperature; // Kept for future potential use or if always null

  HomeServerSystemCpuInfo({
    this.total,
    this.idle,
    this.temperature,
  });

  factory HomeServerSystemCpuInfo.fromJson(Map<String, dynamic> json) {
    return HomeServerSystemCpuInfo(
      total: safeParseDouble(json['total']),
      idle: safeParseInt(json['idle']),
      temperature: safeParseDouble(
          json['temperature']), // This might be null in your JSON example
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'idle': idle,
      'temperature': temperature,
    };
  }
}

class HomeServerSystemMemoryInfo {
  final int? total;
  final int? free;
  final int? used; // Added 'used' to match JSON

  HomeServerSystemMemoryInfo({
    this.total,
    this.free,
    this.used,
  });

  factory HomeServerSystemMemoryInfo.fromJson(Map<String, dynamic> json) {
    return HomeServerSystemMemoryInfo(
      total: safeParseInt(json['total']),
      free: safeParseInt(json['free']),
      used: safeParseInt(json['used']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'free': free,
      'used': used,
    };
  }

  double? get usageRatio {
    if (total == null || used == null || total! == 0) {
      // Check for total being zero to prevent division by zero
      return null;
    }
    return 1.0 * used! / total!; // Calculate based on 'used'
  }
}

class HomeServerSystemNetworkInfo {
  final String? iface;
  final double? upload;
  final double? download;

  HomeServerSystemNetworkInfo({
    this.iface,
    this.upload,
    this.download,
  });

  factory HomeServerSystemNetworkInfo.fromJson(Map<String, dynamic> json) {
    return HomeServerSystemNetworkInfo(
      iface: json['iface'] as String?, // Made nullable
      upload: safeParseDouble(json['upload']),
      download: safeParseDouble(json['download']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iface': iface,
      'upload': upload,
      'download': download,
    };
  }
}
