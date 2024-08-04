import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class CctvPlayer extends StatefulWidget {
  final String streamUrl; // Add a field to hold the stream URL

  // Constructor with named parameter
  const CctvPlayer({super.key, required this.streamUrl});

  @override
  State<CctvPlayer> createState() => CctvPlayerState();
}

class CctvPlayerState extends State<CctvPlayer> {
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    // Access the streamUrl from the widget
    player.open(Media(widget.streamUrl));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 9.0 / 16.0,
        child: Video(
          controller: controller,
        ),
      ),
    );
  }
}
