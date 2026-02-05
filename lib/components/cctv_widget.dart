import 'package:flutter/material.dart';
import 'package:home_dashboard/models/widget_setting.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class CctvWidget extends StatefulWidget {
  final CctvWidgetSetting setting; // Corrected type

  // Constructor with named parameter
  const CctvWidget(this.setting, {super.key});

  @override
  State<CctvWidget> createState() => CctvWidgetState();
}

class CctvWidgetState extends State<CctvWidget> {
  late final player = Player();
  late final controller = VideoController(player,
      configuration: const VideoControllerConfiguration(
        vo: 'gpu',
        hwdec: 'drm',
        enableHardwareAcceleration: false,
      ));

  @override
  void initState() {
    super.initState();
    // Access the streamUrl from the widget's settings
    // OR try specifically for Allwinner:
    player.open(Media(widget.setting.streamUrl));
    player.setAudioTrack(AudioTrack.no());
    player.setSubtitleTrack(SubtitleTrack.no());
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Video(
      controller: controller,
      controls: NoVideoControls,
    ));
  }
}
