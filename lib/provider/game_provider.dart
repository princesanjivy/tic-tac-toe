import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/check_win.dart';
import 'package:tic_tac_toe/helper/game.dart';
import 'package:tic_tac_toe/helper/random_gen.dart';
import 'package:tic_tac_toe/model/room.dart';
import 'package:tic_tac_toe/model/symbol.dart';

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

  void resetBoard(String refPath, RoomData roomData, int player,
      BuildContext context) async {
    List board = List.generate(generateRandomBoardSize(), (index) => 0);

    await Future.delayed(
      const Duration(seconds: 5),
          () {
        designBoard(board);
        FirebaseDatabase.instance.ref(refPath).update({
          // "board": [0, 0, 0, 0, 0, 0, 0, 0, 0],
          "board": board,
          "round": roomData.round + 1,
        });
        print(
            "$roomPath${roomData.code}/players/${player == PlaySymbol.xInt
                ? 0
                : 1}");
        FirebaseDatabase.instance
            .ref(
            "$roomPath${roomData.code}/players/${player == PlaySymbol.xInt
                ? 0
                : 1}")
            .update({
          "winCount":
          roomData.players[player == PlaySymbol.xInt ? 0 : 1].winCount + 1,
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
