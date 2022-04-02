import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerBox extends StatefulWidget {
  final String path;
  const VideoPlayerBox({Key? key, required this.path}) : super(key: key);

  @override
  State<VideoPlayerBox> createState() => _VideoPlayerBoxState();
}

class _VideoPlayerBoxState extends State<VideoPlayerBox> {
  late VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.path.startsWith("https")) {
        _videoPlayerController = VideoPlayerController.network(widget.path)
          ..initialize().then((value) {
            setState(() {});
          });
      } else {
        _videoPlayerController = VideoPlayerController.file(File(widget.path))
          ..initialize().then((value) {
            setState(() {});
          });
      }
    });
    // _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: 200,
      // color: Colors.amber,
      child: Stack(
        children: [
          _videoPlayerController.value.isInitialized
              ? AspectRatio(
                  aspectRatio: 200 / 280,
                  child: VideoPlayer(_videoPlayerController),
                )
              : Container(),
          Center(
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_videoPlayerController.value.isPlaying) {
                      _videoPlayerController.pause();
                    } else {
                      _videoPlayerController.play();
                    }
                  });
                  // log(_videoPlayerController.toString());
                  // _videoPlayerController.setLooping(true);
                },
                child: CircleAvatar(
                    radius: 15,
                    // minRadius: 12,
                    // maxRadius: 24,
                    backgroundColor:
                        Theme.of(context).highlightColor.withOpacity(.7),
                    child: Icon(
                      _videoPlayerController.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ))),
          )
        ],
      ),
    );
  }
}
