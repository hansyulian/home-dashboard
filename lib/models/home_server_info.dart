import 'package:flutter/material.dart';
import 'package:home_dashboard/utils/safe_parse_double.dart';
import 'package:home_dashboard/utils/safe_parse_int.dart';

class HomeServerInfo {
  final HomeServerSystemInfo system;
  final List<HomeServerHddInfo> hdds;
  final List<HomeServerPingInfo> pings;
  // final HomeServerZpoolInfo zpool;

  HomeServerInfo(
    this.system,
    this.hdds,
    this.pings,
    // this.zpool,
  );

  factory HomeServerInfo.fromJson(Map<String, dynamic> json) {
    var systemJson = json['system'];
    var system = HomeServerSystemInfo.fromJson(systemJson);
    var hddsJson = json['hdds'] as List<dynamic>;
    List<HomeServerHddInfo> hdds =
        hddsJson.map((hddJson) => HomeServerHddInfo.fromJson(hddJson)).toList();
    var pingsJson = (json['pings'] ?? []) as List<dynamic>;
    List<HomeServerPingInfo> pings = pingsJson
        .map((pingJson) => HomeServerPingInfo.fromJson(pingJson))
        .toList();
    // var zpoolJson = json['zpool'];
    // var zpool = HomeServerZpoolInfo.fromJson(zpoolJson);
    return HomeServerInfo(system, hdds, pings);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'system': system.toJson(),
      'hdds': hdds.map((hdd) => hdd.toJson()).toList(),
      'pings': pings.map((ping) => ping.toJson()).toList(),
      // 'zpool': zpool.toJson(),
    };
  }
}

class HomeServerHddInfo {
  final String name;
  final String status;

  HomeServerHddInfo(this.name, this.status);

  factory HomeServerHddInfo.fromJson(Map<String, dynamic> json) {
    String name = json['name'];
    String status = json['status'];
    return HomeServerHddInfo(name, status);
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
  final double? result;
  final List<double> history;

  HomeServerPingInfo(this.target, this.result, this.history);

  factory HomeServerPingInfo.fromJson(Map<String, dynamic> json) {
    String target = json['target'];
    double? result = safeParseDouble(json['result']);
    List<dynamic> historyJson = json['history'] as List<dynamic>;
    List<double> history = historyJson
        .map((record) => safeParseDouble(record) ?? 0.0)
        .toList()
        .cast<double>();
    return HomeServerPingInfo(target, result, history);
  }

  Map<String, dynamic> toJson() {
    return {
      'target': target,
      'result': result,
      'history': history,
    };
  }
}

class HomeServerZpoolInfo {
  final String checksum;
  final String name;
  final String read;
  final String state;
  final String write;
  final List<HomeServerZpoolDriveInfo> drives;

  HomeServerZpoolInfo(
      this.name, this.state, this.write, this.read, this.checksum, this.drives);

  factory HomeServerZpoolInfo.fromJson(Map<String, dynamic> json) {
    var name = json['name'];
    var state = json['state'];
    var write = json['write'];
    var read = json['read'];
    var checksum = json['checksum'];
    var drivesJson = json['drives'] as List<dynamic>;
    var drives = drivesJson
        .map((driveJson) => HomeServerZpoolDriveInfo.fromJson(driveJson))
        .toList();
    return HomeServerZpoolInfo(name, state, write, read, checksum, drives);
  }

  Map<String, dynamic> toJson() {
    return {
      'checksum': checksum,
      'name': name,
      'read': read,
      'write': write,
      'state': state,
      'drives': drives.map((record) => record.toJson()).toList(),
    };
  }
}

class HomeServerZpoolDriveInfo {
  final String checksum;
  final String name;
  final String read;
  final String state;
  final String write;

  HomeServerZpoolDriveInfo(
    this.name,
    this.state,
    this.write,
    this.read,
    this.checksum,
  );

  factory HomeServerZpoolDriveInfo.fromJson(Map<String, dynamic> json) {
    var name = json['name'];
    var state = json['state'];
    var write = json['write'];
    var read = json['read'];
    var checksum = json['checksum'];
    return HomeServerZpoolDriveInfo(name, state, write, read, checksum);
  }

  Map<String, dynamic> toJson() {
    return {
      'checksum': checksum,
      'name': name,
      'read': read,
      'write': write,
      'state': state,
    };
  }
}

class HomeServerSystemInfo {
  HomeServerSystemCpuInfo cpu;
  HomeServerSystemNetworkInfo network;
  HomeServerSystemMemoryInfo memory;

  HomeServerSystemInfo(this.cpu, this.network, this.memory);

  factory HomeServerSystemInfo.fromJson(Map<String, dynamic> json) {
    var cpuJson = json['cpu'];
    var cpu = HomeServerSystemCpuInfo.fromJson(cpuJson);
    var networkJson = json['network'];
    var network = HomeServerSystemNetworkInfo.fromJson(networkJson);
    var memoryJson = json['memory'];
    var memory = HomeServerSystemMemoryInfo.fromJson(memoryJson);
    return HomeServerSystemInfo(cpu, network, memory);
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
  double? usage;
  double? temperature;

  HomeServerSystemCpuInfo(this.usage, this.temperature);

  factory HomeServerSystemCpuInfo.fromJson(Map<String, dynamic> json) {
    var usageJson = json['usage'];
    var usage = safeParseDouble(usageJson);
    var temperatureJson = json['temperature'];
    var temperature = safeParseDouble(temperatureJson);
    return HomeServerSystemCpuInfo(usage, temperature);
  }

  Map<String, dynamic> toJson() {
    return {'usage': usage, 'temperature': temperature};
  }
}

class HomeServerSystemMemoryInfo {
  int? total;
  int? free;

  HomeServerSystemMemoryInfo(this.total, this.free);

  factory HomeServerSystemMemoryInfo.fromJson(Map<String, dynamic> json) {
    var totalJson = json['total'];
    var total = safeParseInt(totalJson);
    var freeJson = json['free'];
    var free = safeParseInt(freeJson);
    return HomeServerSystemMemoryInfo(total, free);
  }

  Map<String, dynamic> toJson() {
    return {'total': total, 'free': free};
  }

  double? get usageRatio {
    if (total == null || free == null) {
      return null;
    }
    var safeTotal = total ?? 1;
    var safeFree = free ?? 1;
    return 1.0 * (safeTotal - safeFree) / safeTotal;
  }
}

class HomeServerSystemNetworkInfo {
  String? iface;
  double? upload;
  double? download;

  HomeServerSystemNetworkInfo(this.iface, this.upload, this.download);

  factory HomeServerSystemNetworkInfo.fromJson(Map<String, dynamic> json) {
    var iface = json['iface'];
    var uploadJson = json['upload'];
    var upload = safeParseDouble(uploadJson);
    var downloadJson = json['download'];
    var download = safeParseDouble(downloadJson);
    return HomeServerSystemNetworkInfo(iface, upload, download);
  }

  Map<String, dynamic> toJson() {
    return {'iface': iface, 'upload': upload, 'download': download};
  }
}
