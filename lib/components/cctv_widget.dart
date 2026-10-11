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
  late final player = Player(
      configuration: const PlayerConfiguration(bufferSize: 512 * 1024));
  late final controller = VideoController(player,
      configuration: const VideoControllerConfiguration(
          enableHardwareAcceleration: false));

  // Minimise live-stream latency: skip long probing, drop caching, and
  // render frames as they arrive instead of syncing to the audio clock.
  Future<void> _applyLowLatency() async {
    final platform = player.platform;
    if (platform is! NativePlayer) return;
    const props = {
      'profile': 'low-latency',
      'cache': 'no',
      'cache-pause': 'no',
      'demuxer-readahead-secs': '0',
      'demuxer-max-bytes': '524288',
      'demuxer-lavf-analyzeduration': '0.1',
      'demuxer-lavf-probesize': '32768',
      'demuxer-lavf-o': 'fflags=+nobuffer+discardcorrupt,rtsp_transport=tcp',
      'untimed': 'yes',
      'video-sync': 'desync',
      'framedrop': 'vo',
      'audio': 'no',
    };
    for (final e in props.entries) {
      await platform.setProperty(e.key, e.value);
    }
  }

  @override
  void initState() {
    super.initState();
    _applyLowLatency().then((_) {
      if (mounted) player.open(Media(widget.setting.streamUrl));
    });
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
