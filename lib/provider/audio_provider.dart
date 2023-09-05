import 'package:flutter/material.dart';
import 'package:tic_tac_toe/helper/audio_controller.dart';

class AudioProvider with ChangeNotifier {
  AudioController audioController = AudioController();

  set playAudio(bool val) {
    audioController.playAudio = val;
    notifyListeners();
  }
}