import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/check_win.dart';
import 'package:tic_tac_toe/helper/game.dart';

class GameProvider with ChangeNotifier {
  bool showLoading = false;

  late Result _result;

  List<int> corners = [];
  Map<int, BorderRadiusGeometry> borders = {};

  Result get result {
    return _result;
  }

  set updateResult(Result r) {
    _result = r;
    notifyListeners();
  }

  void resetBoard(String refPath, BuildContext context) async {
    List board = [
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
    ];
    designBoard(board);
    await Future.delayed(
      const Duration(seconds: 5),
      () {
        FirebaseDatabase.instance.ref(refPath).update({
          // "board": [0, 0, 0, 0, 0, 0, 0, 0, 0],
          "board": board,
        });
        Navigator.pop(context);
      },
    );
  }

  void designBoard(List board) {
    // showLoading = true;
    // notifyListeners();

    List borderRadius = [
      const BorderRadius.only(
        topLeft: Radius.circular(16),
      ),
      const BorderRadius.only(
        topRight: Radius.circular(16),
      ),
      const BorderRadius.only(
        bottomLeft: Radius.circular(16),
      ),
      const BorderRadius.only(
        bottomRight: Radius.circular(16),
      ),
    ];
    corners = findCornerPositions(board.length);
    for (int i = 0; i < corners.length; i++) {
      borders.addAll({corners[i]: borderRadius[i]});
    }

    // showLoading = false;
    // notifyListeners();
  }
}
