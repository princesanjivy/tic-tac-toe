import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/components/button.dart';
import 'package:tic_tac_toe/components/icon_button.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/animation_widget.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/provider/auth_provider.dart';
import 'package:tic_tac_toe/provider/room_provider.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';
import 'package:tic_tac_toe/provider/tictacit_provider.dart';
import 'package:tic_tac_toe/screen/home.dart';
import 'package:tic_tac_toe/screen/lobby.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  TextEditingController roomCodeController = TextEditingController();

  late Navigation navigation;

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

    return Consumer2<ThemeProvider, TicTacItProvider>(
      builder: (context, themeProvider, t, _) {
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
                            // keyboardType: TextInputType.number,
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.digitsOnly,
                            // ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: themeProvider.bgColor,
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
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
                    Consumer2<RoomProvider, GameAuthProvider>(
                      builder: (context, roomProvider, loginProvider, _) {
                        return MyButton(
                          doStateChange: true,
                          msDelay: 1200,
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (roomCodeController.text.isNotEmpty) {
                              // int roomCodeInput = int.parse(
                              //   roomCodeController.text,
                              // );
                              // bool isRoomExist = await roomProvider.isRoomExist(
                              //   roomCodeInput,
                              // );
                              // if (!isRoomExist) {
                              //   Fluttertoast.showToast(
                              //     msg: "Room doesn't exist",
                              //     toastLength: Toast.LENGTH_LONG,
                              //     gravity: ToastGravity.CENTER,
                              //   );
                              //   roomCodeController.clear();
                              // }

                              final String roomCode = roomCodeController.text
                                  .trim();
                              await roomProvider.joinRoom(roomCode, t.token);
                              navigation.changeScreenReplacement(
                                LobbyScreen(roomCode: roomCode),
                                widget,
                              );
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
                      },
                    ),
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
                    Consumer2<RoomProvider, GameAuthProvider>(
                      builder: (context, roomProvider, gameAuthProvider, _) {
                        return MyButton(
                          doStateChange: true,
                          msDelay: 1600,
                          hasRestEffect: true,
                          onPressed: () async {
                            final String roomCode = await roomProvider
                                .createRoom(t.token);
                            navigation.changeScreenReplacement(
                              LobbyScreen(roomCode: roomCode),
                              widget,
                            );
                          },
                          text: "Create room",
                          showLoading: roomProvider.loading,
                        );
                      },
                    ),
                  ],
                ),
              ),
              MyIconButton(
                onPressed: () {
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
        );
      },
    );
  }
}

// class GameScreenController extends StatefulWidget {
//   const GameScreenController({
//     super.key,
//     required this.roomCode,
//     required this.isRoomOwner,
//   });
//
//   final int roomCode;
//   final bool isRoomOwner;
//
//   @override
//   State<GameScreenController> createState() => _GameScreenControllerState();
// }
//
// class _GameScreenControllerState extends State<GameScreenController> {
//   GlobalKey screenshotImgKey = GlobalKey();
//
//   late RoomProvider roomProvider;
//   late Navigation navigation;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//
//     navigation = Navigation(Navigator.of(context));
//     roomProvider = Provider.of<RoomProvider>(context, listen: false);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//
//     print("GameController Disposed");
//     roomProvider.leaveRoom(widget.roomCode, widget.isRoomOwner);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer3<GameProvider, ThemeProvider, RoomProvider>(
//       builder: (context, gameProvider, themeProvider, roomProvider, _) {
//         // RoomData roomData = RoomData.fromJson(
//         //   db.data!.snapshot.value,
//         //   widget.roomCode,
//         // );
//         // print(roomData);
//         if (roomProvider.isRoomDataRec) {
//           RoomData roomData = roomProvider.roomData;
//
//           if (roomData.isStarted) {
//             print("Current board: ${roomData.board}");
//             int player = PlaySymbol.inNum(
//               roomData.turn == PlaySymbol.x ? PlaySymbol.o : PlaySymbol.x,
//             );
//             helper.Result result = helper.checkWin(
//               roomData.board,
//               player,
//               getBoardSize(roomData.board),
//             );
//             if (result.hasWon || !roomData.board.contains(0)) {
//               WidgetsBinding.instance.addPostFrameCallback((_) async {
//                 String wonMsg =
//                     "${(player == PlaySymbol.xInt && widget.isRoomOwner) || (player != PlaySymbol.xInt && !widget.isRoomOwner) ? "You" : "Opponent"} won this round!\n\n";
//                 PopUp.show(
//                   context,
//                   title: result.hasWon ? "Win" : "Game draw",
//                   description:
//                       "${result.hasWon ? wonMsg : ""}Next round restarting in 5 seconds...",
//                   button2Text: "Share",
//                   button1Text: "Rate game",
//                   barrierDismissible: false,
//                   button2OnPressed: () async {
//                     // screenshot and share image
//                     if (kIsWeb) {
//                       Fluttertoast.showToast(
//                         msg: "Oops! Share feature only available in Android",
//                         toastLength: Toast.LENGTH_LONG,
//                         gravity: ToastGravity.CENTER,
//                       );
//                     } else {
//                       final XFile xFile = await screenshotBoard(
//                         screenshotImgKey,
//                       );
//                       Share.shareXFiles([xFile], text: "Had fun?");
//                     }
//                   },
//                   button1OnPressed: () {
//                     launchUrl(Uri.parse(gameLinkAndroid));
//                   },
//                 );
//               });
//               gameProvider.resetBoard(
//                 "${roomData.code}",
//                 roomData,
//                 player,
//                 widget.isRoomOwner,
//                 context,
//               );
//             }
//
//             return GameScreen(
//               screenshotImgKey: screenshotImgKey,
//               roomData: roomData,
//               isRoomOwner: widget.isRoomOwner,
//               result: result,
//             );
//           }
//
//           print(roomData.toJson());
//           print(roomData.players.length);
//           return LobbyScreen(
//             roomData: roomData,
//             isRoomOwner: widget.isRoomOwner,
//           );
//         }
//         return Center(child: CircularProgressIndicator());
//       },
//     );
//   }
// }
