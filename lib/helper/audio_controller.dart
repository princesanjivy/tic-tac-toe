import 'package:audioplayers/audioplayers.dart';

class AudioController {
  static final AudioController _audioController = AudioController._internal();

  bool playAudio = true;
  late AssetSource source;
  AudioPlayer player = AudioPlayer();

  factory AudioController() {
    return _audioController;
  }

  AudioController._internal() {
    init();
  }

  void init() async {
    source = AssetSource("audio/click2.ogg");
  }

  void buttonClick() async {
    if (playAudio) {
      await player.play(source);
    }
  }
}
