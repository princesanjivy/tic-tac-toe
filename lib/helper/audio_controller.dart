import 'package:audioplayers/audioplayers.dart';

class AudioController {
  static bool playAudio = true;
  static AudioPlayer player = AudioPlayer();

  static void buttonClick(String audioClip) {
    if (playAudio) {
      player.stop();
      player.play(AssetSource(audioClip));
    }
  }
}
