import 'package:flutter/material.dart';

bool isTimeOfDayBefore(TimeOfDay a, TimeOfDay b) {
  if (a.hour < b.hour) {
    return true;
  }
  if (a.hour > b.hour) {
    return false;
  }
  if (a.minute < b.minute) {
    return true;
  }
  if (a.minute > b.minute) {
    return false;
  }
  return false;
}
