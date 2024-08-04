import 'package:flutter/material.dart';
import 'package:home_dashboard/components/cctv_player.dart';
import 'package:home_dashboard/models/dashboard_widget.dart';

class WidgetFactory extends StatelessWidget {
  final DashboardWidgetBase spec;

  const WidgetFactory({super.key, required this.spec});

  Widget unimplemented() {
    return const Center(child: Text('Unimplemented'));
  }

  @override
  Widget build(BuildContext context) {
    switch (spec.type) {
      case 'cctv':
        CctvWidget cctvWidget = spec as CctvWidget;
        return CctvPlayer(streamUrl: cctvWidget.streamUrl);
    }
    return unimplemented();
  }
}
