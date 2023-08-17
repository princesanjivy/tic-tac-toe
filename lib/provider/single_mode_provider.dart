import 'package:flutter/material.dart';
import 'package:tic_tac_toe/helper/check_win.dart';
import 'package:tic_tac_toe/helper/game.dart';
import 'package:tic_tac_toe/model/symbol.dart';

class SingleModeProvider with ChangeNotifier {
  List board = List.generate(16, (index) => 0);

  Map<int, int> scores = {PlaySymbol.xInt: 0, PlaySymbol.oInt: 0};
  int round = 1;

  String turn = PlaySymbol.x;
  String playerChose = "";
  String aiChose = "";

  Result result = Result(false, []);

  late BuildContext _context;

  bool doStateChange = false;

  void init(BuildContext c) {
    _context = c;

    playerChose = PlaySymbol.x;
    if (playerChose == PlaySymbol.x) {
      aiChose = PlaySymbol.o;
    } else {
      aiChose = PlaySymbol.x;
      aiMove(aiChose);
    }
  }

  void aiMove(String chose) async {
    doStateChange = true;
    notifyListeners();
    print(board);
    print(turn);
    print(playerChose);
    await Future.delayed(const Duration(milliseconds: 600), () {
      int index =
      findBestMove(board, PlaySymbol.inNum(chose), getBoardSize(board));
      bool skipCheck = false;
      {
        if (index == -1) {
          printOverMsg(chose);
          skipCheck = true;
        } else {
          board[index] = PlaySymbol.inNum(chose);
          turn = (chose == PlaySymbol.x ? PlaySymbol.o : PlaySymbol.x);

          // setState(() {});
          doStateChange = true;
          notifyListeners();
        }
      }

      {
        if (!skipCheck && isGameOver(board)) {
          printOverMsg(chose);
        }
      }
    });
  }

  void printOverMsg(String chose) async {
    Result resultX = checkWin(board, PlaySymbol.xInt, getBoardSize(board));
    Result resultO = checkWin(board, PlaySymbol.oInt, getBoardSize(board));

    if (resultX.hasWon) {
      print("Player 1 (X) wins!");
      result = resultX;
      scores[PlaySymbol.xInt] = scores[PlaySymbol.xInt]! + 1;
    } else if (resultO.hasWon) {
      print("Player 2 (O) wins!");
      result = resultO;
      scores[PlaySymbol.oInt] = scores[PlaySymbol.oInt]! + 1;
    } else {
      print("It's a draw!");
    }

    round += 1;

    // setState(() {});
    doStateChange = true;
    notifyListeners();

    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (context) =>
      const SimpleDialog(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Game over\n\nRestarting in 5 seconds..."),
          ),
        ],
      ),
    );
    await Future.delayed(const Duration(seconds: 5), () {
      // board = [0, 0, 0, 0, 0, 0, 0, 0, 0];
      board = List.generate(16, (index) => 0);
      result = Result(false, []);
      turn = (chose == PlaySymbol.x ? PlaySymbol.o : PlaySymbol.x);

      Navigator.pop(_context);
      // setState(() {});
      doStateChange = true;
      notifyListeners();
    });
  }
}
