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
          enableHardwareAcceleration: true));

  // Minimise live-stream latency: skip long probing, drop caching, and
  // render frames as they arrive instead of syncing to the audio clock.
  Future<void> _applyLowLatency() async {
    final platform = player.platform;
    if (platform is! NativePlayer) return;
    final maxFps = widget.setting.maxFps ?? 5;
    final props = {
      // H618 VPU (Cedrus) is a stateless V4L2 decoder; the -copy variants
      // work without dmabuf/GL interop. Falls back to software if unsupported.
      'hwdec': 'v4l2request-copy,v4l2m2m-copy,auto-copy',
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
      // CPU savers for weak SoCs: cheaper decode, fewer frames to convert/upload.
      'vd-lavc-fast': 'yes',
      'vd-lavc-skiploopfilter': 'all',
      'vd-lavc-threads': '2',
      'vf': 'fps=$maxFps',
      'sws-fast': 'yes',
      'scale': 'bilinear',
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
