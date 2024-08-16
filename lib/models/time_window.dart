import 'package:flutter/material.dart';
import 'package:home_dashboard/utils/pad.dart';

class TimeWindow {
  final TimeOfDay start;
  final TimeOfDay end;

  TimeWindow(this.start, this.end);

  factory TimeWindow.fromJson(Map<String, dynamic> json) {
    List<String> startString = json['start'].split(':');
    List<String> endString = json['end'].split(':');
    TimeOfDay start = TimeOfDay(
        hour: int.parse(startString[0]), minute: int.parse(startString[1]));
    TimeOfDay end = TimeOfDay(
        hour: int.parse(endString[0]), minute: int.parse(endString[1]));
    return TimeWindow(start, end);
  }

  Map<String, dynamic> toJson() {
    return {
      'start': '${pad(start.hour, 2, '0')}:${pad(start.minute, 2, '0')}',
      'end': '${pad(end.hour, 2, '0')}:${pad(end.minute, 2, '0')}',
    };
  }
}
