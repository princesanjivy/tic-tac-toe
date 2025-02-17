import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tic_tac_toe/components/button.dart';
import 'package:tic_tac_toe/components/icon_button.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/components/pop_up.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/animation_widget.dart';
import 'package:tic_tac_toe/helper/check_win.dart' as helper;
import 'package:tic_tac_toe/helper/game.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/helper/screenshot_board.dart';
import 'package:tic_tac_toe/helper/show_banner_ad.dart';
import 'package:tic_tac_toe/helper/show_interstitial_ad.dart';
import 'package:tic_tac_toe/model/room.dart';
import 'package:tic_tac_toe/model/symbol.dart';
import 'package:tic_tac_toe/provider/game_provider.dart';
import 'package:tic_tac_toe/provider/login_provider.dart';
import 'package:tic_tac_toe/provider/room_provider.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';
import 'package:tic_tac_toe/screen/game.dart';
import 'package:tic_tac_toe/screen/home.dart';
import 'package:tic_tac_toe/screen/lobby.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  TextEditingController roomCodeController = TextEditingController();

  late Navigation navigation;

  BottomBannerAd ad = BottomBannerAd();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    navigation = Navigation(Navigator.of(context));
  }

  @override
  void dispose() {
    super.dispose();

    print("Room Dispose");
  }

  @override
  Widget build(BuildContext context) {
    double width = kIsWeb ? 400 : MediaQuery.of(context).size.width;

    return Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
      return Scaffold(
        backgroundColor: themeProvider.bgColor,
        body: Stack(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimationOnWidget(
                    useIncomingEffect: true,
                    incomingEffect:
                        WidgetTransitionEffects.incomingSlideInFromTop(
                      delay: const Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn,
                    ),
                    child: Text(
                      "Enter room code and join with your friend",
                      style: TextStyle(
                        fontSize: defaultTextSize,
                        color: themeProvider.secondaryColor,
                      ),
                    ),
                  ),
                  const VerticalSpacer(32),
                  AnimationOnWidget(
                    msDelay: 800,
                    child: Material(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: themeProvider.primaryColor,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: SizedBox(
                        height: 48,
                        width: width / 1.6,
                        child: TextField(
                          controller: roomCodeController,
                          style: TextStyle(
                            color: themeProvider.primaryColor,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          // maxLength: 6,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: themeProvider.bgColor,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.zero,
                            hintText: "Enter room code",
                            hintStyle: TextStyle(
                              color: themeProvider.primaryColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalSpacer(16),
                  Consumer2<RoomProvider, LoginProvider>(
                      builder: (context, roomProvider, loginProvider, _) {
                    return MyButton(
                      doStateChange: true,
                      msDelay: 1200,
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (roomCodeController.text.isNotEmpty) {
                          int roomCodeInput =
                              int.parse(roomCodeController.text);
                          bool isRoomExist =
                              await roomProvider.isRoomExist(roomCodeInput);
                          if (!isRoomExist) {
                            Fluttertoast.showToast(
                              msg: "Room doesn't exist",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                            );
                            roomCodeController.clear();
                          } else {
                            await roomProvider.joinRoom(
                              loginProvider.getUserData,
                              roomCodeInput,
                              widget,
                            );

                            bool isRoomOwner = false;

                            FullScreenAd.object.show();

                            navigation.changeScreenReplacement(
                              GameScreenController(
                                roomCode: roomCodeInput,
                                isRoomOwner: isRoomOwner,
                              ),
                              widget,
                            );
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg: "Please enter a room code",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                          );
                        }
                      },
                      text: "Join",
                      showLoading: roomProvider.showJoinLoading,
                    );
                  }),
                  const VerticalSpacer(32),
                  AnimationOnWidget(
                    useIncomingEffect: true,
                    incomingEffect:
                        WidgetTransitionEffects.incomingSlideInFromTop(
                      delay: const Duration(milliseconds: 2000),
                      curve: Curves.fastOutSlowIn,
                    ),
                    child: Text(
                      "or",
                      style: TextStyle(
                        fontSize: defaultTextSize,
                        color: themeProvider.secondaryColor,
                      ),
                    ),
                  ),
                  const VerticalSpacer(32),
                  Consumer2<RoomProvider, LoginProvider>(
                      builder: (context, roomProvider, loginProvider, _) {
                    return MyButton(
                      doStateChange: true,
                      msDelay: 1600,
                      hasRestEffect: true,
                      onPressed: () async {
                        int roomCode = await roomProvider.createRoom(
                          loginProvider.getUserData,
                          widget,
                        );

                        bool isRoomOwner = true;

                        navigation.changeScreenReplacement(
                          GameScreenController(
                            roomCode: roomCode,
                            isRoomOwner: isRoomOwner,
                          ),
                          widget,
                        );
                      },
                      text: "Create room",
                      showLoading: roomProvider.loading,
                    );
                  }),
                ],
              ),
            ),
            MyIconButton(
              onPressed: () {
                FullScreenAd.object.show();

                navigation.changeScreenReplacement(
                  const HomeScreen(),
                  widget,
                );
              },
              msDelay: 2000,
              iconData: Icons.arrow_back_ios_new_rounded,
            ),
          ],
        ),
        bottomNavigationBar: ad.showBanner(),
      );
    });
  }
}

class GameScreenController extends StatefulWidget {
  const GameScreenController({
    super.key,
    required this.roomCode,
    required this.isRoomOwner,
  });

  final int roomCode;
  final bool isRoomOwner;

  @override
  State<GameScreenController> createState() => _GameScreenControllerState();
}

class _GameScreenControllerState extends State<GameScreenController> {
  GlobalKey screenshotImgKey = GlobalKey();

  late RoomProvider roomProvider;
  late Navigation navigation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    navigation = Navigation(Navigator.of(context));
    roomProvider = Provider.of<RoomProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    print("GameController Disposed");
    roomProvider.leaveRoom(
      widget.roomCode,
      widget.isRoomOwner,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GameProvider, ThemeProvider>(
      builder: (context, gameProvider, themeProvider, _) {
        return StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance
              .ref("$roomPath${widget.roomCode}/")
              .onValue,
          builder: (context, db) {
            if (!db.hasData) {
              return Scaffold(
                backgroundColor: themeProvider.bgColor,
                body: Center(
                  child: CircularProgressIndicator(
                    color: themeProvider.primaryColor,
                    strokeWidth: 2,
                  ),
                ),
              );
            }
            if (db.data!.snapshot.value == null) {
              print("Room closed/deleted in firestore!");
              return const HomeScreen();
            }
            RoomData roomData = RoomData.fromJson(
              db.data!.snapshot.value,
              widget.roomCode,
            );
            // print(roomData);

            if (roomData.isStarted) {
              print("Current board: ${roomData.board}");
              int player = PlaySymbol.inNum(
                roomData.turn == PlaySymbol.x ? PlaySymbol.o : PlaySymbol.x,
              );
              helper.Result result = helper.checkWin(
                roomData.board,
                player,
                getBoardSize(roomData.board),
              );
              if (result.hasWon || !roomData.board.contains(0)) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  String wonMsg =
                      "${(player == PlaySymbol.xInt && widget.isRoomOwner) || (player != PlaySymbol.xInt && !widget.isRoomOwner) ? "You" : "Opponent"} won this round!\n\n";
                  PopUp.show(
                    context,
                    title: result.hasWon ? "Win" : "Game draw",
                    description:
                        "${result.hasWon ? wonMsg : ""}Next round restarting in 5 seconds...",
                    button2Text: "Share",
                    button1Text: "Rate game",
                    barrierDismissible: false,
                    button2OnPressed: () async {
                      // screenshot and share image
                      if (kIsWeb) {
                        Fluttertoast.showToast(
                          msg: "Oops! Share feature only available in Android",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                        );
                      } else {
                        final XFile xFile =
                            await screenshotBoard(screenshotImgKey);
                        Share.shareXFiles([xFile], text: "Had fun?");
                      }
                    },
                    button1OnPressed: () {
                      launchUrl(
                        Uri.parse(Platform.isIOS ? gameLinkIos: gameLinkAndroid),
                      );
                    },
                  );
                });
                gameProvider.resetBoard(
                  "$roomPath${roomData.code}",
                  roomData,
                  player,
                  widget.isRoomOwner,
                  context,
                );
              }

              return GameScreen(
                screenshotImgKey: screenshotImgKey,
                roomData: roomData,
                isRoomOwner: widget.isRoomOwner,
                result: result,
              );
            }

            print(roomData.toJson());
            print(roomData.players.length);
            return LobbyScreen(
              roomData: roomData,
              isRoomOwner: widget.isRoomOwner,
            );
          },
        );
      },
    );
  }
}
