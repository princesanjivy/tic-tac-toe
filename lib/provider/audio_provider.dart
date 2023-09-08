import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/helper/audio_controller.dart';

class AudioProvider with ChangeNotifier {
  AudioController audioController = AudioController();

  bool _canPlayAudio = true;

  AudioProvider.init() {
    // showLoading = true;
    // notifyListeners();

    getPrefs();
  }

  void getPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? val = preferences.getBool("isLight");

    if (val == null) {
      _canPlayAudio = true;
    } else {
      _canPlayAudio = val;
    }

    print("Can playAudio: $_canPlayAudio");
    // showLoading = false;
    notifyListeners();
  }

  void setPrefs(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("canPlayAudio", value);
  }

  bool get canPlayAudio {
    return _canPlayAudio;
  }

  void setPlayAudio() {
    _canPlayAudio = !_canPlayAudio;

    setPrefs(_canPlayAudio);
    // audioController.playAudio = _canPlayAudio;
    notifyListeners();
  }
}
