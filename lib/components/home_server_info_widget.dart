import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:home_dashboard/components/grid.dart';
import 'package:home_dashboard/components/space.dart';
import 'package:home_dashboard/models/home_server_info.dart';
import 'package:home_dashboard/models/widget_setting.dart';
import 'package:home_dashboard/modules/home_server_info_driver.dart';
import 'package:home_dashboard/utils/decimal_aligner.dart';
import 'package:home_dashboard/utils/log_scaler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeServerInfoWidget extends StatefulWidget {
  final HomeServerInfoWidgetSetting setting;
  const HomeServerInfoWidget(this.setting, {super.key});

  @override
  State<StatefulWidget> createState() => HomeServerInfoWidgetState();
}

const maxNetworkSpeed = 12 * 1024 * 1024;

class HomeServerInfoWidgetState extends State<HomeServerInfoWidget> {
  late Timer _timer;
  late HomeServerInfoDriver _homeServerInfoDriver;
  late HomeServerInfo _info;
  double maxScale = 0.0;

  HomeServerInfoWidgetState() {}

  @override
  void initState() {
    super.initState();
    _homeServerInfoDriver = HomeServerInfoDriver(widget.setting.apiEndpoint);
    _info = HomeServerInfo(
      HomeServerSystemInfo(
        HomeServerSystemCpuInfo(null, null),
        HomeServerSystemNetworkInfo(null, null, null),
        HomeServerSystemMemoryInfo(null, null),
      ),
      [],
      [],
      // HomeServerZpoolInfo('', '', '', '', '', [])
    );
    _fetchData();
    _startFetcher();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void _startFetcher() {
    _timer = Timer.periodic(Duration(seconds: widget.setting.refreshInSecond),
        (timer) async {
      _fetchData();
    });
  }

  void _fetchData() async {
    var responseData = await _homeServerInfoDriver.safeRetrieve();
    setState(() {
      _info = responseData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        renderSystem(),
        renderPings(),
        renderHdds(),
        // renderZpool()
      ]),
    );
  }

  Widget renderSystem() {
    num uploadRate =
        pow(1.0 * (_info.system.network.upload ?? 0) / maxNetworkSpeed, 0.5);
    num downloadRate =
        pow(1.0 * (_info.system.network.download ?? 0) / maxNetworkSpeed, 0.5);

    List<UsageData> usageData = [
      UsageData('CPU', logScaler(_info.system.cpu.usage ?? 0)),
      UsageData('Memory', (_info.system.memory.usageRatio ?? 0)),
      UsageData('Upload', uploadRate),
      UsageData('Download', downloadRate)
    ];
    return SizedBox(
        height: 150,
        child: Center(
          child: SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            primaryYAxis: const NumericAxis(
              minimum: 0,
              maximum: 1,
              interval: 0.1,
              labelStyle: const TextStyle(color: Colors.transparent),
            ),
            series: [
              BarSeries<UsageData, String>(
                dataSource: usageData,
                xValueMapper: (UsageData data, _) => data.category,
                yValueMapper: (UsageData data, _) => data.usagePercentage,
                dataLabelSettings: const DataLabelSettings(isVisible: false),
                animationDuration: 0,
                animationDelay: 0,
              ),
            ],
          ),
        ));
  }

  Widget renderHdds() {
    bool shouldVisible = false;
    var hdds = _info.hdds;
    for (int i = 0; i < hdds.length; i++) {
      if (hdds[i].status != 'standby') {
        shouldVisible = true;
      }
    }
    if (!shouldVisible) {
      return Container();
    }

    return Column(
      children: [
        Space(),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [renderText("Drive Status")]),
        Space(),
        Grid(
          hdds,
          (item, index) => Card(
            color: item.indicatorColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [renderText(item.name), renderText(item.status)]),
            ),
          ),
          columns: 2,
          horizontalGap: 8,
          verticalGap: 8,
        ),
      ],
    );
  }

  Widget renderPings() {
    List<Widget> children = [Space(), renderText("Ping Status"), Space()];
    for (int i = 0; i < _info.pings.length; i++) {
      var record = _info.pings[i];
      children.add(
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        renderText(record.target),
        renderText(
            '${decimalAligner(record.result ?? 0, left: 3, right: 3)} ms'),
      ]));
      children.add(Space());
    }
    children.add(renderPingGraph());
    return Column(
      children: children,
    );
  }

  Widget renderPingGraph() {
    // Map pingInfos to list of histories, replacing null values with 0.0
    List<PingDataHolder> pingDataHolders = _info.pings.map((pingInfo) {
      double min = double.infinity;
      double max = 0;
      double average = 0;
      int total = 0;
      List<double> scaledValues = [];

      for (var value in pingInfo.history) {
        if (value != 0) {
          min = min < value ? min : value;
          max = max > value ? max : value;
          average += value;
          total += 1;
          scaledValues.add(value);
        } else {
          scaledValues.add(-1);
        }
      }

      if (total > 0) {
        average = average / total;
      }

      for (var i = 0; i < scaledValues.length; i++) {
        if (scaledValues[i] >= 0) {
          var valueScale = (scaledValues[i] - min) / (max - min);
          scaledValues[i] = valueScale;
        }
      }

      return PingDataHolder(
        scaledValues,
        min,
        max,
        average,
      );
    }).toList(); // Convert map iterable to list.

    pingDataHolders.sort((a, b) => a.average.compareTo(b.average));

    return SizedBox(
      height: 100,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(
          isVisible: false,
        ),
        primaryYAxis: NumericAxis(
          isVisible: false,
          minimum: 0,
          maximum: pingDataHolders.length * 4,
        ),
        series: pingDataHolders.asMap().entries.map((entry) {
          int index = entry.key;
          PingDataHolder data = entry.value;

          // Map scaled values for each series
          final pingInfo = data.scaledValues.map((sv) {
            return sv == -1 ? 0.0 : sv + index * 4.0 + 1.0;
          }).toList();

          // Create a LineSeries for each PingDataHolder
          return LineSeries<double, int>(
            dataSource: pingInfo,
            xValueMapper: (_, idx) => idx, // Map index as x-axis
            yValueMapper: (ping, _) => ping, // Map ping values as y-axis
            animationDuration: 0, // Disable animation
            dataLabelSettings: const DataLabelSettings(isVisible: false),
            enableTooltip: false,
          );
        }).toList(),
        // .map((pingInfo, index) => LineSeries<double, int>(
        //       dataSource: pingInfo,
        //       xValueMapper: (_, index) => index, // Map index as x-axis
        //       yValueMapper: (ping, _) => ping, // Map ping values as y-axis
        //       animationDuration: 0, // Disable animation
        //       dataLabelSettings: const DataLabelSettings(isVisible: false),
        //       enableTooltip: false,
        //     ))
        // .toList(),
      ),
    );
  }

  // Widget renderZpool() {
  //   bool hasWarning = _info.zpool.state != 'ONLINE';
  //   if (!hasWarning) {
  //     return Container();
  //   }
  //   return Column(children: [
  //     Space(),
  //     Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [renderText("Warnings", color: Colors.red)]),
  //     Space(),
  //     renderText('${_info.zpool.name}: ${_info.zpool.state}', color: Colors.red)
  //   ]);
  // }

  Widget renderText(String text, {Color color = Colors.white}) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 16,
        height: 1.0,
        fontWeight: FontWeight.w300,
        decoration: TextDecoration.none,
      ),
    );
  }
}

class UsageData {
  UsageData(this.category, this.usagePercentage);
  final String category;
  final num usagePercentage;
}

class PingDataHolder {
  final double min;
  final double max;
  final double average;

  final List<double> scaledValues;
  PingDataHolder(this.scaledValues, this.min, this.max, this.average);
}
