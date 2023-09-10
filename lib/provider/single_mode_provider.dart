import 'package:flutter/material.dart';
import 'package:tic_tac_toe/components/pop_up.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/board_desgin.dart' as helper;
import 'package:tic_tac_toe/helper/check_win.dart';
import 'package:tic_tac_toe/helper/game.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/helper/random_gen.dart';
import 'package:tic_tac_toe/helper/show_interstitial_ad.dart';
import 'package:tic_tac_toe/model/symbol.dart';
import 'package:tic_tac_toe/screen/home.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleModeProvider with ChangeNotifier {
  List board = List.generate(9, (index) => 0); // Always start with 3*3 board

  Map<int, int> scores = {PlaySymbol.xInt: 0, PlaySymbol.oInt: 0};
  int round = 1;

  String turn = PlaySymbol.x;
  String playerChose = "";
  String aiChose = "";

  Result result = Result(false, []);

  late BuildContext _context;
  late Widget _widget;
  late bool _twoPlayerMode;

  bool doStateChange = false;

  List<int> corners = [];
  Map<int, BorderRadiusGeometry> borders = {};

  late Navigation navigation;

  void init(BuildContext c, Widget w, bool b) {
    _context = c;
    _widget = w;
    _twoPlayerMode = b;

    playerChose = PlaySymbol.x;
    if (playerChose == PlaySymbol.x) {
      aiChose = PlaySymbol.o;
    } else {
      aiChose = PlaySymbol.x;
      aiMove(aiChose);
    }
    design();
    navigation = Navigation(Navigator.of(c));
  }

  void validate() async {
    Result resultX = checkWin(board, PlaySymbol.xInt, getBoardSize(board));
    Result resultO = checkWin(board, PlaySymbol.oInt, getBoardSize(board));

    if (resultX.hasWon) {
      print("Player 1 (X) wins!");
      result = resultX;
      scores[PlaySymbol.xInt] = scores[PlaySymbol.xInt]! + 1;
      displayTwoPlayerModeResult(PlaySymbol.x);
    } else if (resultO.hasWon) {
      print("Player 2 (O) wins!");
      result = resultO;
      scores[PlaySymbol.oInt] = scores[PlaySymbol.oInt]! + 1;
      displayTwoPlayerModeResult(PlaySymbol.o);
    } else {
      if (!board.contains(0)) {
        displayTwoPlayerModeResult(PlaySymbol.draw);
      }
    }

    doStateChange = true;
    notifyListeners();
  }

  void displayTwoPlayerModeResult(String winner) async {
    round += 1;

    PopUp.show(
      _context,
      title: winner == PlaySymbol.draw
          ? "Game draw"
          : winner == PlaySymbol.x
          ? "X won"
          : "O won",
      description: "New game restarting in 3 seconds...",
      button1Text: "Quit",
      button2Text: "Rate game",
      barrierDismissible: false,
      button1OnPressed: () {
        FullScreenAd.object.show();

        navigation.goBack(_context);
        navigation.changeScreenReplacement(
          const HomeScreen(),
          _widget,
        );
      },
      button2OnPressed: () {
        launchUrl(
          Uri.parse(gameLinkAndroid),
        );
      },
    );
    await Future.delayed(const Duration(seconds: 3), () {
      board = List.generate(generateRandomBoardSize(), (index) => 0);

      result = Result(false, []);
      turn = (winner == PlaySymbol.x ? PlaySymbol.o : PlaySymbol.x);

      navigation.goBack(_context);
      doStateChange = true;
      design();

      notifyListeners();
    });
  }

  void aiMove(String chose) async {
    doStateChange = true;
    notifyListeners();

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

    doStateChange = true;
    notifyListeners();

    PopUp.show(
      _context,
      title: "Game over",
      description: "New game restarting in 5 seconds...",
      button1Text: "Quit",
      button2Text: "Rate game",
      barrierDismissible: false,
      button1OnPressed: () {
        FullScreenAd.object.show();

        navigation.goBack(_context);
        navigation.changeScreenReplacement(
          const HomeScreen(),
          _widget,
        );
      },
      button2OnPressed: () {
        launchUrl(
          Uri.parse(gameLinkAndroid),
        );
      },
    );
    await Future.delayed(const Duration(seconds: 5), () {
      board = List.generate(generateRandomBoardSize(), (index) => 0);

      result = Result(false, []);
      turn = (chose == PlaySymbol.x ? PlaySymbol.o : PlaySymbol.x);

      navigation.goBack(_context);
      doStateChange = true;
      design();

      notifyListeners();
    });
  }

  void design() {
    helper.BoardDesign bd = helper.boardDesign(board);
    corners = bd.corners;
    borders = bd.borders;
  }
}
