import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import '../resizer/responsive_util.dart';
import 'package:video_player/video_player.dart';

class VideoItems extends StatefulWidget {
  // final VideoPlayerController videoPlayerController;
  final bool? looping;
  final bool? autoplay;
  final String? videoUrl;
  VideoItems({
    // @required this.videoPlayerController,
    this.looping,
    this.autoplay,
    this.videoUrl,
    Key? key,
  }) : super(key: key);

  @override
  _VideoItemsState createState() => _VideoItemsState();
}

class _VideoItemsState extends State<VideoItems> {
  VideoPlayerController? videoPlayerController;
  ChewieController? _chewieController = null;
  int a = 0;

  @override
  void initState() {
    super.initState();
    // Timer(Duration(seconds: 1), () {
    setupData();
    // });
  }

  setupData() {
    // videoPlayerController = VideoPlayerController.asset('assets/video_5.mp4');
    if (widget.videoUrl != null) {
      // ignore: unrelated_type_equality_checks
      final _validURL = File(widget.videoUrl!).isAbsolute;
      _validURL
          ? videoPlayerController =
              VideoPlayerController.file(File(widget.videoUrl!))
          : videoPlayerController =
              VideoPlayerController.network(widget.videoUrl!);
      // videoPlayerController = VideoPlayerController.file(File(widget.videoUrl));
    } else {
      videoPlayerController = VideoPlayerController.network(
          'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4');
    }
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      aspectRatio: 8 / 5,
      autoInitialize: true,
      autoPlay: widget.autoplay!,
      looping: widget.looping!,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );

    // setState(() {
    //   a = 10;
    // });
  }

  @override
  void dispose() {
    super.dispose();
    if (_chewieController != null) {
      _chewieController!.dispose();
    }
  }

/*
ResponsiveUtil(
        child: SizedBox(width: 200, height: 200, child: getImage()));
  }
   */
  @override
  Widget build(BuildContext context) {
    return ResponsiveUtil(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _chewieController != null
              ? Chewie(
                  controller: _chewieController!,
                )
              : Text('data'),
        ),
      ),
    );
  }
}
