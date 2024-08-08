import 'package:flutter/material.dart';
import 'package:home_dashboard/components/cctv_widget.dart';
import 'package:home_dashboard/components/clock_widget.dart';
import 'package:home_dashboard/components/coin_tracker_widget.dart';
import 'package:home_dashboard/models/widget_setting.dart';

class WidgetFactory extends StatelessWidget {
  final WidgetSetting spec;

  const WidgetFactory({super.key, required this.spec});

  Widget unimplemented() {
    return const Center(child: Text('Unimplemented'));
  }

  Widget blank() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    switch (spec.type) {
      case 'cctv':
        CctvWidgetSetting cctvWidget = spec as CctvWidgetSetting;
        return CctvWidget(cctvWidget);
      case 'clock':
        ClockWidgetSetting clockWidget = spec as ClockWidgetSetting;
        return ClockWidget(clockWidget);
      case 'coinTracker':
        CoinTrackerWidgetSetting coinTrackerWidget =
            spec as CoinTrackerWidgetSetting;
        return CoinTrackerWidget(coinTrackerWidget);
      case 'blank':
        return blank();
    }
    return unimplemented();
  }
}
