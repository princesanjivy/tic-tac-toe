import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/check_win.dart';

class GameProvider with ChangeNotifier {
  late Result _result;

  Result get result {
    return _result;
  }

  set updateResult(Result r) {
    _result = r;
    notifyListeners();
  }

  void resetBoard(String refPath, BuildContext context) async {
    await Future.delayed(
      const Duration(seconds: 5),
      () {
        FirebaseDatabase.instance.ref(refPath).update({
          // "board": [0, 0, 0, 0, 0, 0, 0, 0, 0],
          "board": [
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0
          ],
        });
        Navigator.pop(context);
      },
    );
  }
}
