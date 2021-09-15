import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../audioplayer/player_widget.dart';
import '../resizer/responsive_util.dart';

const kUrl1 = 'https://luan.xyz/files/audio/ambient_c_motion.mp3';
const kUrl2 = 'https://luan.xyz/files/audio/nasa_on_a_mission.mp3';
const kUrl3 = 'http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1xtra_mf_p';

class NEditorAPlayer extends StatefulWidget {
  const NEditorAPlayer({Key? key}) : super(key: key);

  @override
  _NEditorAPlayerState createState() => _NEditorAPlayerState();
}

class _NEditorAPlayerState extends State<NEditorAPlayer> {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  String? localFilePath;
  String? localAudioCacheURI;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // Calls to Platform.isIOS fails on web
      return;
    }
    if (Platform.isIOS) {
      audioCache.fixedPlayer?.notificationService?.startHeadlessService();
      advancedPlayer.notificationService.startHeadlessService();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveUtil(
      child: SizedBox(
        width: 300,
        height: 300,
        child: localAsset(),
      ),
    );
  }

  Widget remoteUrl() {
    return SingleChildScrollView(
        child: Column(
      children: [
        Text(
          'Sample 1 ($kUrl1)',
          key: Key('url1'),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        PlayerWidget(url: kUrl1),
      ],
    ));
  }

  Widget localAsset() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text("Play Local Asset 'audio.mp3':"),
          _Btn(txt: 'Play', onPressed: () => audioCache.play('audio.mp3')),
          const Text("Play Local Asset (via byte source) 'audio.mp3':"),
          _Btn(
            txt: 'Play',
            onPressed: () async {
              final bytes = await (await audioCache.loadAsFile('audio.mp3'))
                  .readAsBytes();
              audioCache.playBytes(bytes);
            },
          ),
          const Text("Play Local Asset In Low Latency 'audio2.mp3':"),
          _Btn(
            txt: 'Play',
            onPressed: () {
              audioCache.play('audio2.mp3', mode: PlayerMode.LOW_LATENCY);
            },
          ),
          getLocalFileDuration(),
        ],
      ),
    );
  }

  FutureBuilder<int> getLocalFileDuration() {
    return FutureBuilder<int>(
      future: _getDuration(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('No Connection...');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return const Text('Awaiting result...');
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return Text(
              'audio2.mp3 duration is: ${Duration(milliseconds: snapshot.data!)}',
            );
          default:
            return Container();
        }
      },
    );
  }

  Future<int> _getDuration() async {
    final uri = await audioCache.load('audio2.mp3');
    await advancedPlayer.setUrl(uri.toString());
    return Future.delayed(
      const Duration(seconds: 2),
      () => advancedPlayer.getDuration(),
    );
  }
}

class _Btn extends StatelessWidget {
  final String? txt;
  final VoidCallback? onPressed;

  const _Btn({Key? key, @required this.txt, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 48.0,
      child: ElevatedButton(child: Text(txt!), onPressed: onPressed),
    );
  }
}
