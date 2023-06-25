import 'package:flutter/material.dart';
import 'package:tic_tac_toe/helper/audio_controller.dart';

class AudioProvider with ChangeNotifier {
  set playAudio(bool val) {
    AudioController.playAudio = val;
    notifyListeners();
  }
}