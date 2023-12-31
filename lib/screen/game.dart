import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/components/button.dart';
import 'package:tic_tac_toe/components/icon_button.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/components/player_card.dart';
import 'package:tic_tac_toe/components/pop_up.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/animation_widget.dart';
import 'package:tic_tac_toe/helper/check_win.dart';
import 'package:tic_tac_toe/helper/game.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/helper/show_banner_ad.dart';
import 'package:tic_tac_toe/helper/show_interstitial_ad.dart';
import 'package:tic_tac_toe/model/player.dart';
import 'package:tic_tac_toe/model/room.dart';
import 'package:tic_tac_toe/model/symbol.dart';
import 'package:tic_tac_toe/provider/game_provider.dart';
import 'package:tic_tac_toe/provider/login_provider.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';
import 'package:tic_tac_toe/screen/room.dart';
import 'package:vibration/vibration.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.roomData,
    required this.isRoomOwner,
    required this.result,
    required this.screenshotImgKey,
  });

  final RoomData roomData;
  final bool isRoomOwner;
  final Result result;
  final GlobalKey screenshotImgKey;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Navigation navigation;

  BottomBannerAd ad = BottomBannerAd();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // nameless(){
    GameProvider gameProvider = Provider.of<GameProvider>(context);
    gameProvider.designBoard(widget.roomData.board);

    navigation = Navigation(Navigator.of(context));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<LoginProvider, GameProvider, ThemeProvider>(
      builder: (context, loginProvider, gameProvider, themeProvider, _) {
        // See if any player leaves the game, show popup and go to HomeScreen()
        if (widget.roomData.players.length <= 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            PopUp.show(
              context,
              title: "Oops!",
              description: "Player 1 has left the game.\n"
                  "Do you want to wait a player to join back?",
              button1Text: "Yes",
              button2Text: "Leave",
              barrierDismissible: false,
              button1OnPressed: () async {
                navigation.goBack(context);
              },
              button2OnPressed: () async {
                navigation.goBack(context);
                // To remove GameController Widget
                await navigation.changeScreenReplacement(
                  const RoomScreen(),
                  widget,
                );
              },
            );
          });

          return Scaffold(
            backgroundColor: themeProvider.bgColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Waiting for Player to join...",
                    style: TextStyle(
                      fontSize: defaultTextSize + 2,
                      color: themeProvider.secondaryColor,
                    ),
                  ),
                  const VerticalSpacer(8),
                  MyButton(
                    text: "Leave game",
                    msDelay: 100,
                    onPressed: () async {
                      // To remove GameController Widget
                      await navigation.changeScreenReplacement(
                        const RoomScreen(),
                        widget,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: themeProvider.bgColor,
          body: Stack(
            children: [
              RepaintBoundary(
                key: widget.screenshotImgKey,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AnimationOnWidget(
                            msDelay: 400,
                            doStateChange: true,
                            child: PlayerCard(
                              imageUrl:
                                  loginProvider.getUserData.displayPicture,
                              name:
                                  "You (${widget.roomData.players[!widget.isRoomOwner ? 1 : 0].chose})",
                              showScore: true,
                              scoreValue: widget
                                  .roomData
                                  .players[!widget.isRoomOwner ? 1 : 0]
                                  .winCount,
                            ),
                          ),
                          AnimationOnWidget(
                            msDelay: 1200,
                            doStateChange: true,
                            child: Text(
                              "Round\n${widget.roomData.round}",
                              style: GoogleFonts.hennyPenny(
                                fontSize: defaultTextSize - 2,
                                color: themeProvider.primaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          FutureBuilder<Player>(
                            future: loginProvider.getUserById(widget.roomData
                                .players[widget.isRoomOwner ? 1 : 0].playerId),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator(
                                    color: themeProvider.bgColor);
                              }
                              return AnimationOnWidget(
                                msDelay: 400,
                                doStateChange: true,
                                child: PlayerCard(
                                  imageUrl: snapshot.data!.displayPicture,
                                  name:
                                      "${snapshot.data!.name.split(" ")[0]} (${widget.roomData.players[widget.isRoomOwner ? 1 : 0].chose})",
                                  showScore: true,
                                  scoreValue: widget
                                      .roomData
                                      .players[widget.isRoomOwner ? 1 : 0]
                                      .winCount,
                                ),
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
                      AnimationOnWidget(
                        useIncomingEffect: true,
                        incomingEffect:
                            WidgetTransitionEffects.incomingScaleDown(
                          delay: const Duration(milliseconds: 800),
                          curve: Curves.fastOutSlowIn,
                        ),
                        doStateChange: true,
                        child: Padding(
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
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    getBoardSize(widget.roomData.board),
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
                                                .players[
                                                    !widget.isRoomOwner ? 1 : 0]
                                                .chose) {
                                      if (!kIsWeb) {
                                        Vibration.vibrate(
                                            duration: 80, amplitude: 120);
                                      }
                                      FirebaseDatabase.instance
                                          .ref(
                                            "$roomPath${widget.roomData.code}/board/$index",
                                          )
                                          .set(PlaySymbol.inNum(
                                              widget.roomData.turn));
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
                                      color: widget.result.positions
                                              .contains(index)
                                          ? Colors.deepOrange.withOpacity(0.8)
                                          : themeProvider.bgColor,
                                      border: Border.all(
                                        color: themeProvider.primaryColor,
                                        // width: 2,
                                      ),
                                      borderRadius:
                                          gameProvider.corners.contains(index)
                                              ? gameProvider.borders[index]
                                              : null,
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.roomData.board[index] ==
                                                PlaySymbol.xInt
                                            ? PlaySymbol.x
                                            : widget.roomData.board[index] ==
                                                    PlaySymbol.oInt
                                                ? PlaySymbol.o
                                                : "",
                                        style: GoogleFonts.hennyPenny(
                                          fontSize: 42 - 8,
                                          color: widget.result.positions
                                                  .contains(index)
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
                      ),
                      const VerticalSpacer(4),
                      AnimationOnWidget(
                        msDelay: 1200,
                        doStateChange: true,
                        hasRestEffect: true,
                        incomingEffect: WidgetTransitionEffects.incomingScaleUp(
                          delay: const Duration(milliseconds: 1200),
                          curve: Curves.easeInOut,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: themeProvider.secondaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            (widget.roomData.turn ==
                                    widget
                                        .roomData
                                        .players[!widget.isRoomOwner ? 1 : 0]
                                        .chose)
                                ? "Your turn"
                                : "Opponent turn",
                            style: TextStyle(
                              fontSize: defaultTextSize,
                              color: themeProvider.bgColor,
                            ),
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
              ),
              MyIconButton(
                msDelay: 1200,
                iconData: Icons.arrow_back_ios_new_rounded,
                onPressed: () {
                  FullScreenAd.object.show();

                  PopUp.show(
                    context,
                    title: "Warning",
                    description: "Are you sure want to leave the game?",
                    button1Text: "Yes",
                    button2Text: "No",
                    barrierDismissible: false,
                    button1OnPressed: () async {
                      navigation.goBack(context);
                      // To remove GameController Widget
                      await navigation.changeScreenReplacement(
                        const RoomScreen(),
                        widget,
                      );
                    },
                    button2OnPressed: () {
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
          bottomNavigationBar: ad.showBanner(),
        );
      },
    );
  }
}
