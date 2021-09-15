import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NEditorYTPlayer extends StatefulWidget {
  const NEditorYTPlayer({Key? key, this.foo, this.child, this.videoId})
      : super(key: key);
  final Widget? child;
  final bool? foo;
  @required
  final String? videoId;

  @override
  _NEditorYTPlayerState createState() => _NEditorYTPlayerState();
}

class _NEditorYTPlayerState extends State<NEditorYTPlayer> {
  YoutubePlayerController? controller;
  @override
  void initState() {
    super.initState();
    setupController();
  }

  setupController() {
    String videoId = widget.videoId!;

    setState(() {
      if (controller == null) {
        controller = YoutubePlayerController(
          initialVideoId: videoId, //Add videoID.
          flags: const YoutubePlayerFlags(
            hideControls: false,
            controlsVisibleAtStart: true,
            autoPlay: false,
            mute: false,
          ),
        );
      } else {
        controller!.load(videoId);
      }
    });
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    if (controller != null) {
      controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (controller != null) {
      controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return createYoutubeView();
  }

  Widget createYoutubeView() {
    if (controller != null) {
      return YoutubePlayer(
        controller: controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
      );
    }
    return Text('');
  }
}
