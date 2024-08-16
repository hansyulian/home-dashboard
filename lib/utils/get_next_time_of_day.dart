import 'package:flutter/material.dart';

DateTime getNextTimeOfDay(TimeOfDay timeOfDay) {
  DateTime now = DateTime.now();

  // Create a DateTime with the same date as 'now' but with the hour and minute from 'timeOfDay'
  DateTime result =
      DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);

  // If the result is before the current time, add one day
  if (result.isBefore(now)) {
    result = result.add(const Duration(days: 1));
  }

  return result;
}
