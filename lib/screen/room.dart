import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/components/button.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/animation_widget.dart';
import 'package:tic_tac_toe/helper/audio_controller.dart';
import 'package:tic_tac_toe/helper/check_win.dart' as helper;
import 'package:tic_tac_toe/helper/game.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/model/room.dart';
import 'package:tic_tac_toe/model/symbol.dart';
import 'package:tic_tac_toe/provider/game_provider.dart';
import 'package:tic_tac_toe/provider/login_provider.dart';
import 'package:tic_tac_toe/provider/room_provider.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';
import 'package:tic_tac_toe/screen/game.dart';
import 'package:tic_tac_toe/screen/home.dart';
import 'package:tic_tac_toe/screen/lobby.dart';
import 'package:vibration/vibration.dart';
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
                        borderRadius: BorderRadius.all(
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
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: themeProvider.bgColor,
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
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
                          } else {
                            await roomProvider.joinRoom(
                              loginProvider.getUserData,
                              roomCodeInput,
                              widget,
                            );

                            bool isRoomOwner = false;
                            navigation
                                .changeScreenReplacement(
                              GameScreenController(
                                roomCode: roomCodeInput,
                                isRoomOwner: isRoomOwner,
                              ),
                              widget,
                            )
                                .then((value) async {
                              /// delete the room;
                              await Future.delayed(
                                  const Duration(milliseconds: 800));
                              roomProvider.leaveRoom(
                                  roomCodeInput, isRoomOwner);
                            });
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
            Positioned(
              top: 32,
              right: 32,
              child: AnimationOnWidget(
                msDelay: 2000,
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
                    backgroundColor: MaterialStateProperty.all<Color>(
                        themeProvider.primaryColor),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded, // TODO: temp icon
                    color: themeProvider.bgColor,
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
    });
  }
}

class GameScreenController extends StatelessWidget {
  const GameScreenController({
    super.key,
    required this.roomCode,
    required this.isRoomOwner,
  });

  final int roomCode;
  final bool isRoomOwner;

  @override
  Widget build(BuildContext context) {
    return Consumer2<GameProvider, ThemeProvider>(
      // TODO: remove this if not needed
      builder: (context, gameProvider, themeProvider, _) {
        return StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance.ref("$roomPath$roomCode/").onValue,
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
            RoomData roomData = RoomData.fromJson(
              db.data!.snapshot.value,
              roomCode,
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
                print("Game over");
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const SimpleDialog(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child:
                              Text("Game over\n\nRestarting in 5 seconds..."),
                        ),
                      ],
                    ),
                  );
                });
                gameProvider.resetBoard(
                  "$roomPath${roomData.code}",
                  roomData,
                  player,
                  isRoomOwner,
                  context,
                );
              }

              return GameScreen(
                roomData: roomData,
                isRoomOwner: isRoomOwner,
                result: result,
              );
            }

            return LobbyScreen(
              roomData: roomData,
              isRoomOwner: isRoomOwner,
            );
          },
        );
      },
    );
  }
}
