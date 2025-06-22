import 'dart:async';

import 'package:flutter/material.dart';
import 'package:home_dashboard/models/widget_setting.dart';
import 'package:home_dashboard/modules/home_sensor_driver.dart';
import 'package:home_dashboard/utils/value_ratio.dart';

const torrentMinDistance = 20.0;
const torrentMaxDistance = 120.0;

class HomeSensorWidget extends StatefulWidget {
  final HomeSensorWidgetSetting setting;
  const HomeSensorWidget(this.setting, {super.key});

  @override
  State<StatefulWidget> createState() => HomeSensorWidgetState();
}

class HomeSensorWidgetState extends State<HomeSensorWidget> {
  late Timer _timer;
  late HomeSensorDriver _homeSensorDriver;
  HomeSensorResponse _sensors = HomeSensorResponse();

  HomeSensorWidgetState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _homeSensorDriver = HomeSensorDriver(widget.setting.apiEndpoint);
    _startFetcher();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void _startFetcher() {
    _fetchSensorData();
    _timer = Timer.periodic(Duration(seconds: widget.setting.refreshInSecond),
        (timer) async {
      _fetchSensorData();
    });
  }

  void _fetchSensorData() async {
    var responseData = await _homeSensorDriver.safeRetrieve();
    setState(() {
      _sensors = responseData;
    });
  }

  double get torrentRatio {
    return 1 -
        valueRatio(_sensors.waterTorrent?.value ?? torrentMaxDistance,
            torrentMinDistance, torrentMaxDistance);
  }

  String get torrentLabel {
    var percentage = (torrentRatio * 100).toStringAsFixed(0);
    return percentage;
  }

  Color get torrentColor {
    if (torrentRatio > 0.5) {
      return Colors.green;
    }
    if (torrentRatio > 0.3) {
      return Colors.yellow;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity, // Fill the available width
        height: double.infinity, // Fill the available height
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 16.0,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Box at the bottom with dynamic height and clipped to border radius
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: constraints.maxHeight * torrentRatio,
                    color: torrentColor, // Box color
                  ),
                ),
                // Text centered both vertically and horizontally
                Center(
                  child: Text(
                    torrentLabel,
                    style: const TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 48, // Text size
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
