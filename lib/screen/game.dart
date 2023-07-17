import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/components/player_card.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/check_win.dart';
import 'package:tic_tac_toe/helper/game.dart';
import 'package:tic_tac_toe/model/player.dart';
import 'package:tic_tac_toe/model/room.dart';
import 'package:tic_tac_toe/model/symbol.dart';
import 'package:tic_tac_toe/provider/game_provider.dart';
import 'package:tic_tac_toe/provider/login_provider.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';

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

// 0 1 2 3
// 4 5 6 7
// 8 9 10 11
// 12 13 14 15

// 0 1 2 3 4
// 5 6 7 8 9
// 10 11 12 13 14
// 15 16 17 18 19
// 20 21 22 23 24

class _GameScreenState extends State<GameScreen> {
  // List<int> corners = [0, 4, 20, 24];
  // Map<int, BorderRadiusGeometry> borders = {
  //   0: const BorderRadius.only(
  //     topLeft: Radius.circular(16),
  //   ),
  //   4: const BorderRadius.only(
  //     topRight: Radius.circular(16),
  //   ),
  //   20: const BorderRadius.only(
  //     bottomLeft: Radius.circular(16),
  //   ),
  //   24: const BorderRadius.only(
  //     bottomRight: Radius.circular(16),
  //   ),
  // };

  // @override
  // void initState() {
  //   super.initState();
  //
  //   change();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // nameless(){
    GameProvider gameProvider = Provider.of<GameProvider>(context);
    gameProvider.designBoard(widget.roomData.board);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<LoginProvider, GameProvider, ThemeProvider>(
      builder: (context, loginProvider, gameProvider, themeProvider, _) {
        // if (gameProvider.showLoading) {
        //   return Scaffold(
        //     backgroundColor: bgColor,
        //     body: Center(
        //       child: CircularProgressIndicator(
        //         color: primaryColor,
        //         strokeWidth: 2,
        //       ),
        //     ),
        //   );
        // }
        return Scaffold(
          backgroundColor: themeProvider.bgColor,
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
                      name:
                          "You (${widget.roomData.players[!widget.isRoomOwner ? 1 : 0].chose})",
                      showScore: true,
                      scoreValue: widget.roomData
                          .players[!widget.isRoomOwner ? 1 : 0].winCount,
                    ),
                    Text(
                      "Round\n${widget.roomData.round}",
                      style: GoogleFonts.hennyPenny(
                        fontSize: defaultTextSize - 2,
                        color: themeProvider.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    FutureBuilder<Player>(
                      future: loginProvider.getUserById(widget.roomData
                          .players[widget.isRoomOwner ? 1 : 0].playerId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator(
                              color: themeProvider.bgColor);
                        }
                        return PlayerCard(
                          imageUrl: snapshot.data!.displayPicture,
                          name:
                              "${snapshot.data!.name.split(" ")[0]} (${widget.roomData.players[widget.isRoomOwner ? 1 : 0].chose})",
                          showScore: true,
                          scoreValue: widget.roomData
                              .players[widget.isRoomOwner ? 1 : 0].winCount,
                        );
                      },
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
                      color: themeProvider.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: getBoardSize(widget.roomData.board),
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
                                  : themeProvider.bgColor,
                              border: Border.all(
                                color: themeProvider.primaryColor,
                                // width: 2,
                              ),
                              borderRadius: gameProvider.corners.contains(index)
                                  ? gameProvider.borders[index]
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
                                      ? themeProvider.bgColor
                                      : themeProvider.primaryColor,
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
                    color: themeProvider.secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    (widget.roomData.turn ==
                            widget.roomData.players[!widget.isRoomOwner ? 1 : 0]
                                .chose)
                        ? "Your turn"
                        : "Opponent turn",
                    style: TextStyle(
                      fontSize: defaultTextSize,
                      color: themeProvider.bgColor,
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
        );
      },
    );
  }
}
