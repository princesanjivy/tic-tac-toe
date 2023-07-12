import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/components/player_card.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/audio_controller.dart';
import 'package:tic_tac_toe/helper/check_win.dart';
import 'package:tic_tac_toe/helper/game.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/helper/random_gen.dart';
import 'package:tic_tac_toe/model/symbol.dart';
import 'package:tic_tac_toe/screen/home.dart';
import 'package:vibration/vibration.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class SingleModeScreen extends StatefulWidget {
  const SingleModeScreen({super.key});

  @override
  State<SingleModeScreen> createState() => _SingleModeScreenState();
}

class _SingleModeScreenState extends State<SingleModeScreen> {
  List<int> corners = [0, 2, 6, 8];
  List board = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  Map<int, BorderRadiusGeometry> borders = {
    0: const BorderRadius.only(
      topLeft: Radius.circular(16),
    ),
    2: const BorderRadius.only(
      topRight: Radius.circular(16),
    ),
    6: const BorderRadius.only(
      bottomLeft: Radius.circular(16),
    ),
    8: const BorderRadius.only(
      bottomRight: Radius.circular(16),
    ),
  };

  late Navigation navigation;
  late String playerChose;
  late String aiChose;
  Result result = Result(false, []);

  String turn = PlaySymbol.x;

  /// player with `x` gets first chance.

  @override
  void initState() {
    super.initState();

    playerChose = generateRandomPlaySymbol();
    // playerChose = PlaySymbol.x;
    if (playerChose == PlaySymbol.x) {
      aiChose = PlaySymbol.o;
    } else {
      aiChose = PlaySymbol.x;
      playAi(aiChose);
    }
  }

  playAi(String t) async {
    await Future.delayed(const Duration(milliseconds: 800), () {
      int index = findBestMove(board, PlaySymbol.inNum(t));
      bool skipCheck = false;
      {
        if (index == -1) {
          printOverMsg(t);
          skipCheck = true;
        } else {
          board[index] = PlaySymbol.inNum(t);
          turn = (t == PlaySymbol.x ? PlaySymbol.o : PlaySymbol.x);

          setState(() {});
        }
      }

      {
        if (!skipCheck && isGameOver(board)) {
          printOverMsg(t);
        }
      }
    });
  }

  printOverMsg(t) async {
    Result resultX = checkWin(board, PlaySymbol.xInt, 3);
    Result resultO = checkWin(board, PlaySymbol.oInt, 3);

    if (resultX.hasWon) {
      print("Player 1 (X) wins!");
      result = resultX;
    } else if (resultO.hasWon) {
      print("Player 2 (O) wins!");
      result = resultO;
    } else {
      print("It's a draw!");
    }

    setState(() {});

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const SimpleDialog(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Game over\n\nRestarting in 5 seconds..."),
          ),
        ],
      ),
    );
    await Future.delayed(const Duration(seconds: 5), () {
      board = [0, 0, 0, 0, 0, 0, 0, 0, 0];
      result = Result(false, []);
      turn = (t == PlaySymbol.x ? PlaySymbol.o : PlaySymbol.x);

      Navigator.pop(context);
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    navigation = Navigation(Navigator.of(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PlayerCard(
                      imageUrl:
                          "https://cdn.landesa.org/wp-content/uploads/default-user-image.png",
                      name: "You ($playerChose)",
                      showScore: true,
                      scoreValue: 0,
                    ),
                    Text(
                      "Round\n1",
                      style: GoogleFonts.hennyPenny(
                        fontSize: defaultTextSize - 2,
                        color: primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    PlayerCard(
                      imageUrl:
                          "https://cdn.dribbble.com/users/497773/screenshots/6580509/virtual_reality_icon_02.png",
                      name: "AI ($aiChose)",
                      showScore: true,
                      scoreValue: 0,
                    ),
                    // PlayerCard(
                    //   imageUrl: imageUrl,
                    //   name: "Opponent",
                    //   showScore: true,
                    //   scoreValue: 0,
                    // ),
                  ],
                ),
                const VerticalSpacer(16),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Container(
                    width: kIsWeb ? 500 : null,
                    height: kIsWeb ? 500 : null,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: getBoardSize(board),
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        // childAspectRatio: 1,
                      ),
                      itemCount: board.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // print(widget.roomData.board);
                            // result = checkWin(
                            //   widget.roomData.board,
                            //   PlaySymbol.inNum(widget.roomData.turn),
                            // );
                            print(board);
                            print(turn);
                            print(playerChose);
                            if (board[index] == 0 && turn == playerChose) {
                              board[index] = PlaySymbol.inNum(turn);
                              turn = (turn == PlaySymbol.x
                                  ? PlaySymbol.o
                                  : PlaySymbol.x);

                              setState(() {});

                              playAi(turn);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: result.positions.contains(index)
                                  ? Colors.deepOrange.withOpacity(0.8)
                                  : bgColor,
                              border: Border.all(
                                color: primaryColor,
                                // width: 2,
                              ),
                              borderRadius: corners.contains(index)
                                  ? borders[index]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                board[index] == PlaySymbol.xInt
                                    ? PlaySymbol.x
                                    : board[index] == PlaySymbol.oInt
                                        ? PlaySymbol.o
                                        : "",
                                style: GoogleFonts.hennyPenny(
                                  fontSize: 42 - 8,
                                  color: result.positions.contains(index)
                                      ? bgColor
                                      : primaryColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const VerticalSpacer(4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    (turn == playerChose) ? "Your turn" : "AI turn",
                    style: TextStyle(
                      fontSize: defaultTextSize,
                      color: bgColor,
                    ),
                  ),
                ),
                // const VerticalSpacer(8),
                // Text(
                //   widget.roomData.players[!widget.isRoomOwner ? 1 : 0].chose,
                //   style: GoogleFonts.hennyPenny(
                //     fontSize: 32,
                //     color: primaryColor,
                //   ),
                // ),
              ],
            ),
          ),
          Positioned(
            top: 32,
            right: 32,
            child: WidgetAnimator(
              incomingEffect: WidgetTransitionEffects.incomingScaleUp(
                delay: const Duration(milliseconds: 1200),
                curve: Curves.easeInOut,
              ),
              child: ElevatedButton(
                onPressed: () {
                  Vibration.vibrate(duration: 80, amplitude: 120);
                  AudioController.buttonClick("audio/click2.ogg");

                  // Navigation.goBack(context);
                  navigation.changeScreenReplacement(
                    const HomeScreen(),
                    widget,
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(48, 48),
                  ),
                  elevation: MaterialStateProperty.all<double>(4),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(0)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryColor),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded, // TODO: temp icon
                  color: bgColor,
                ),
                // child: Text(
                //   "i",
                //   style: TextStyle(
                //     fontSize: defaultTextSize,
                //     color: bgColor,
                //     letterSpacing: 1,
                //   ),
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
