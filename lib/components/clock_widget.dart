import 'dart:async';

import 'package:flutter/material.dart';
import 'package:home_dashboard/models/widget_setting.dart';
import 'package:home_dashboard/utils/date_utils.dart';
import 'package:home_dashboard/utils/pad.dart';

class ClockWidget extends StatefulWidget {
  final ClockWidgetSetting setting;
  const ClockWidget(this.setting, {super.key});

  @override
  State<ClockWidget> createState() => ClockWidgetState();
}

class ClockWidgetState extends State<ClockWidget> {
  late Timer _timer;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    // Calculate milliseconds to the next full second
    final int millisecondsToNextSecond = 1000 - DateTime.now().millisecond;
    _timer = Timer(Duration(milliseconds: millisecondsToNextSecond), () {
      // Update the state for the initial second
      setState(() {
        now = DateTime.now();
      });

      // Start the periodic timer
      _startPeriodicTimer();
    });
  }

  void _startPeriodicTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double baseSize = 100;
    double widgetSettingSize = widget.setting.size ?? 1.0;
    double bigTextSize = widgetSettingSize * baseSize;
    double smallTextSize = widgetSettingSize * baseSize * 0.25;
    String dayOfWeek = getDayOfWeek(now.weekday);
    String month = getMonth(now.month);
    String day = pad(now.day, 2, '0');
    String hour = pad(now.hour, 2, '0');
    String minute = pad(now.minute, 2, '0');
    String second = pad(now.second, 2, '0');

    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: [
          ClockText(dayOfWeek, smallTextSize),
          ClockText('$day/$month', smallTextSize),
          const SizedBox(height: 20),
          ClockText(hour, bigTextSize),
          ClockText(minute, bigTextSize),
          ClockText(second, smallTextSize),
        ]));
  }
}

class ClockText extends StatelessWidget {
  final String text;
  final double size;
  const ClockText(this.text, this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFFFFFFFF), // Set the text color here
        fontSize: size, // You can also set other text styles like font size
        height: 1.0,
        decoration: TextDecoration.none,
      ),
    );
  }
}
