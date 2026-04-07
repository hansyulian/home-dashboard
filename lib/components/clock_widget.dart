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
    _scheduleClock();
  }

  void _updateTime() {
    if (mounted) {
      setState(() {
        now = DateTime.now();
      });
    }
  }

  void _scheduleClock() {
    final int millisecondsToNextSecond =
        1000 - DateTime.now().millisecond + 100;
    _timer = Timer(Duration(milliseconds: millisecondsToNextSecond), () {
      _updateTime();
      _startPeriodicTimer();
    });
  }

  void _startPeriodicTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double baseSize = 100;
    final double widgetSettingSize = widget.setting.size ?? 1.0;
    final double bigTextSize = widgetSettingSize * baseSize;
    final double smallTextSize = widgetSettingSize * baseSize * 0.25;

    final String dayOfWeek = getDayOfWeek(now.weekday);
    final String month = getMonth(now.month);
    final String day = pad(now.day, 2, '0');
    final String hour = pad(now.hour, 2, '0');
    final String minute = pad(now.minute, 2, '0');
    final String second = pad(now.second, 2, '0');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClockText(dayOfWeek, smallTextSize),
          ClockText('$day/$month', smallTextSize),
          const SizedBox(height: 20),
          ClockText(hour, bigTextSize),
          ClockText(minute, bigTextSize),
          ClockText(second, smallTextSize),
        ],
      ),
    );
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
        color: const Color(0xFFFFFFFF),
        fontSize: size,
        height: 1.0,
        decoration: TextDecoration.none,
      ),
    );
  }
}
