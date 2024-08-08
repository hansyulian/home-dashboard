import 'package:home_dashboard/utils/safe_parse_double.dart';

abstract class HomeSensor {
  String get type;
  final String lastTimestamp;

  HomeSensor(this.lastTimestamp);

  factory HomeSensor.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'waterTorrent':
        return WaterTorrentHomeSensor.fromJson(json);
    }
    return UnknownSensor(json);
  }

  Map<String, dynamic> toJson();
}

class UnknownSensor extends HomeSensor {
  Map<String, dynamic> json;

  UnknownSensor(this.json) : super(json['lastTimestamp']);

  factory UnknownSensor.fromJson(Map<String, dynamic> json) {
    return UnknownSensor(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return json;
  }

  @override
  String get type => 'unknown';
}

class WaterTorrentHomeSensor extends HomeSensor {
  final bool detected;
  final double? value;

  WaterTorrentHomeSensor(this.value, this.detected, lastTimestamp)
      : super(lastTimestamp);

  factory WaterTorrentHomeSensor.fromJson(Map<String, dynamic> json) {
    var value = safeParseDouble(json['value']);
    var detected = json['detected'];
    var lastTimestamp = json['lastTimestamp'];
    return WaterTorrentHomeSensor(value, detected, lastTimestamp);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      'detected': detected,
    };
  }

  @override
  String get type => 'waterTorrent';
}
