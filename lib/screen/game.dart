import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/check_win.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/components/player_card.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/model/room.dart';
import 'package:tic_tac_toe/model/symbol.dart';
import 'package:tic_tac_toe/provider/login_provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.roomData,
    required this.isRoomOwner,
    required this.result,
  });

  final RoomData roomData;
  final bool isRoomOwner;
  final Result result;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

// 0 1 2
// 3 4 5
// 6 7 8

class _GameScreenState extends State<GameScreen> {
  List<int> corners = [0, 2, 6, 8];
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

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, _) {
        return Scaffold(
          backgroundColor: bgColor,
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PlayerCard(
                      imageUrl: loginProvider.getUserData.displayPicture,
                      name: "You",
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
                      imageUrl: imageUrl,
                      name: "Opponent",
                      showScore: true,
                      scoreValue: 0,
                    ),
                  ],
                ),
                const VerticalSpacer(16),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Container(
                    // width: 300,
                    // height: 300,
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
                        crossAxisCount:
                            sqrt(widget.roomData.board.length).toInt(),
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        // childAspectRatio: 1,
                      ),
                      itemCount: widget.roomData.board.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // print(widget.roomData.board);
                            // result = checkWin(
                            //   widget.roomData.board,
                            //   PlaySymbol.inNum(widget.roomData.turn),
                            // );
                            if (widget.roomData.board[index] == 0 &&
                                widget.roomData.turn ==
                                    widget
                                        .roomData
                                        .players[!widget.isRoomOwner ? 1 : 0]
                                        .chose) {
                              FirebaseDatabase.instance
                                  .ref(
                                    "$roomPath${widget.roomData.code}/board/$index",
                                  )
                                  .set(PlaySymbol.inNum(widget.roomData.turn));
                              FirebaseDatabase.instance
                                  .ref(
                                    "$roomPath${widget.roomData.code}/turn",
                                  )
                                  .set(
                                    widget.roomData.turn == PlaySymbol.x
                                        ? PlaySymbol.o
                                        : PlaySymbol.x,
                                  );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: widget.result.positions.contains(index)
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
                                widget.roomData.board[index] == PlaySymbol.xInt
                                    ? PlaySymbol.x
                                    : widget.roomData.board[index] ==
                                            PlaySymbol.oInt
                                        ? PlaySymbol.o
                                        : "",
                                style: GoogleFonts.hennyPenny(
                                  fontSize: 42 - 8,
                                  color: widget.result.positions.contains(index)
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
                    "Your turn",
                    style: TextStyle(
                      fontSize: defaultTextSize,
                      color: bgColor,
                    ),
                  ),
                ),
                const VerticalSpacer(8),
                Text(
                  widget.roomData.players[!widget.isRoomOwner ? 1 : 0].chose,
                  style: GoogleFonts.hennyPenny(
                    fontSize: 32,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
