import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/check_win.dart';
import 'package:tic_tac_toe/components/button.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/audio_controller.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/model/room.dart';
import 'package:tic_tac_toe/model/symbol.dart';
import 'package:tic_tac_toe/provider/game_provider.dart';
import 'package:tic_tac_toe/provider/login_provider.dart';
import 'package:tic_tac_toe/provider/room_provider.dart';
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
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Enter room code and join with your friend",
                  style: TextStyle(
                    fontSize: defaultTextSize,
                    color: secondaryColor,
                  ),
                ),
                const VerticalSpacer(32),
                Material(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: primaryColor,
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
                        color: primaryColor,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      // maxLength: 6,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: bgColor,
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.zero,
                        hintText: "Enter room code",
                        hintStyle: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalSpacer(16),
                WidgetAnimator(
                  incomingEffect: WidgetTransitionEffects.incomingScaleUp(
                    delay: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  ),
                  child: Consumer2<RoomProvider, LoginProvider>(
                      builder: (context, roomProvider, loginProvider, _) {
                    return MyButton(
                      onPressed: () async {
                        int roomCode = await roomProvider.joinRoom(
                          loginProvider.getUserData,
                          int.parse(roomCodeController.text),
                          widget,
                        );

                        navigation.changeScreenReplacement(
                          GameScreenController(
                            roomCode: roomCode,
                            isRoomOwner: false,
                          ),
                          widget,
                        );
                      },
                      text: "Join",
                    );
                  }),
                ),
                const VerticalSpacer(32),
                TextAnimator(
                  // TODO: change this animation
                  "or",
                  initialDelay: const Duration(milliseconds: 1200),
                  incomingEffect:
                      WidgetTransitionEffects.incomingSlideInFromLeft(),
                  style: TextStyle(
                    fontSize: defaultTextSize,
                    color: secondaryColor,
                  ),
                ),
                const VerticalSpacer(32),
                WidgetAnimator(
                  incomingEffect: WidgetTransitionEffects.incomingScaleUp(
                    delay: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                  ),
                  atRestEffect: WidgetRestingEffects.wave(),
                  child: Consumer2<RoomProvider, LoginProvider>(
                      builder: (context, roomProvider, loginProvider, _) {
                    return MyButton(
                      onPressed: () async {
                        int roomCode = await roomProvider.createRoom(
                          loginProvider.getUserData,
                          widget,
                        );

                        navigation.changeScreenReplacement(
                          GameScreenController(
                            roomCode: roomCode,
                            isRoomOwner: true,
                          ),
                          widget,
                        );
                      },
                      text: "Create room",
                      showLoading: roomProvider.loading,
                    );
                  }),
                ),
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
    return Consumer<GameProvider>(
      // TODO: remove this if not needed
      builder: (context, gameProvider, _) {
        return StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance.ref("$roomPath$roomCode/").onValue,
          builder: (context, db) {
            if (!db.hasData) {
              return Scaffold(
                backgroundColor: bgColor,
                body: Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
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

              // TODO: implement below in GameScreen
              Result result = checkWin(
                roomData.board,
                PlaySymbol.inNum(
                  roomData.turn == PlaySymbol.x ? PlaySymbol.o : PlaySymbol.x,
                ),
              );
              if (result.hasWon || !roomData.board.contains(0)) {
                print("Game over");
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
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
                gameProvider.resetBoard("$roomPath${roomData.code}", context);
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
