import 'package:home_dashboard/models/time_window.dart';
import 'package:home_dashboard/utils/is_time_of_day_before.dart';

bool isInTimeWindow(DateTime dateTime, TimeWindow timeWindow) {
  DateTime startComparison = DateTime(dateTime.year, dateTime.month,
      dateTime.day, timeWindow.start.hour, timeWindow.start.minute);
  DateTime endComparison = DateTime(dateTime.year, dateTime.month, dateTime.day,
      timeWindow.end.hour, timeWindow.end.minute);
  bool isStartBeforeDateTime = startComparison.isBefore(dateTime);
  bool isEndBeforeDateTime = endComparison.isBefore(dateTime);
  bool isEndBeforeStart = isTimeOfDayBefore(timeWindow.end, timeWindow.start);
  if (!isEndBeforeStart) {
    // eg: 10am - 6pm
    return isStartBeforeDateTime && !isEndBeforeDateTime;
  } else {
    // eg: 10 pm - 6am;
    return isStartBeforeDateTime || !isEndBeforeDateTime;
  }
}
