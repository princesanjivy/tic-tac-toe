import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/provider/audio_provider.dart';

class AudioController {
  static final AudioController _audioController = AudioController._internal();

  // bool playAudio = true;
  late AssetSource source;
  AudioPlayer player = AudioPlayer();

  factory AudioController() {
    return _audioController;
  }

  AudioController._internal() {
    init();
  }

  void init() async {
    source = AssetSource("audio/click2.mp3");
  }

  void buttonClick(BuildContext context) async {
    AudioProvider audioProvider =
        Provider.of<AudioProvider>(context, listen: false);
    if (audioProvider.canPlayAudio) {
      await player.play(source);
    }
  }
}
