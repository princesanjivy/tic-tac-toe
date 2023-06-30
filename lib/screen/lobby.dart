import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tic_tac_toe/components/button.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/components/player_card.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/audio_controller.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/model/player.dart';
import 'package:tic_tac_toe/model/room.dart';
import 'package:tic_tac_toe/provider/login_provider.dart';
import 'package:tic_tac_toe/provider/room_provider.dart';
import 'package:tic_tac_toe/screen/game.dart';
import 'package:tic_tac_toe/screen/room.dart';
import 'package:vibration/vibration.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({
    super.key,
    required this.roomCode,
    required this.isRoomOwner,
  });

  final int roomCode;
  final bool isRoomOwner;

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, _) {
        return StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance
              .ref("$roomPath${widget.roomCode}/")
              .onValue,
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
            print(db.data!.snapshot.value);
            RoomData roomData =
                RoomData.fromJson(db.data!.snapshot.value, widget.roomCode);
            // List players = db.data!.snapshot.value as List;
            print(roomData.players);
            if (roomData.isStarted) {
              return GameScreen(
                roomData: roomData,
                isRoomOwner: widget.isRoomOwner,
              );
            }
            return Scaffold(
              backgroundColor: bgColor,
              body: Stack(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(borderRadius),
                              border: Border.all(
                                color: primaryColor,
                                width: 2,
                              ),
                              color: bgColor,
                              boxShadow: shadow,
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Share this room code\nwith your friend",
                                      style: TextStyle(
                                        fontSize: defaultTextSize,
                                        color: secondaryColor,
                                      ),
                                    ),
                                    const VerticalSpacer(12),
                                    Text(
                                      "${widget.roomCode}",
                                      style: GoogleFonts.hennyPenny(
                                        fontSize: 24,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),

                                /// share button
                                Positioned(
                                  top: 20,
                                  right: 10,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Share.share(
                                        "Tic Tac Toe Online room code is : ${widget.roomCode}",
                                      );
                                    },
                                    style: ButtonStyle(
                                      minimumSize:
                                          MaterialStateProperty.all<Size>(
                                        const Size(48, 48),
                                      ),
                                      elevation:
                                          MaterialStateProperty.all<double>(4),
                                      shape: MaterialStateProperty.all<
                                          OutlinedBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              const EdgeInsets.all(0)),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              primaryColor),
                                    ),
                                    child: Icon(
                                      Icons.share_rounded,
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
                              ],
                            ),
                          ),
                        ),
                        const VerticalSpacer(32),

                        /// players vs opponent display cards
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            PlayerCard(
                              imageUrl:
                                  loginProvider.getUserData.displayPicture,
                              name: loginProvider.getUserData.name,
                            ),
                            Text(
                              "vs",
                              style: GoogleFonts.hennyPenny(
                                fontSize: defaultTextSize,
                                color: primaryColor,
                              ),
                            ),
                            roomData.players.length == 2
                                ? FutureBuilder<Player>(
                                    future: loginProvider.getUserById(roomData
                                        .players[widget.isRoomOwner ? 1 : 0]
                                        .playerId),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return CircularProgressIndicator(
                                            color: bgColor);
                                      }
                                      return PlayerCard(
                                        imageUrl: snapshot.data!.displayPicture,
                                        name: snapshot.data!.name,
                                      );
                                    },
                                  )
                                : PlayerCard(
                                    imageUrl: imageUrl,
                                    name: "Opponent",
                                  ),
                          ],
                        ),
                        const VerticalSpacer(84),
                        roomData.players.length == 2
                            ? Container()
                            : Text(
                                "Waiting for player to join...",
                                style: TextStyle(
                                  fontSize: defaultTextSize - 4,
                                  color: secondaryColor,
                                ),
                              ),
                        roomData.players.length == 2
                            ? Container()
                            : const VerticalSpacer(8),

                        Consumer<RoomProvider>(
                            builder: (context, roomProvider, _) {
                          return MyButton(
                            text: roomData.players.length == 2
                                ? "Start"
                                : "Waiting...",
                            onPressed: () {
                              if (widget.isRoomOwner) {
                                roomProvider.isStarted(true, widget.roomCode);
                              } else {
                                Fluttertoast.showToast(
                                  msg: "You can't start the game",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                );
                              }
                              // Navigation.changeScreenReplacement(
                              //   context,
                              //   const GameScreen(),
                              //   widget,
                              // );
                            },
                            showLoading:
                                roomData.players.length == 2 ? false : true,
                          );
                        }),
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

                          // TODO: show confirmation pop & close the room i.e delete record in db
                          // Navigation.goBack(context);
                          Navigation.changeScreenReplacement(
                            context,
                            const RoomScreen(),
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
          },
        );
      },
    );
  }
}

// {"chose": "O", "id": "mpy0Iz7hPWMGQOVYOv15y8o3VlI3"} Prince Sanjivy
// {"chose": "O", "id": "acokUiqN5nXAnL9axIn36PRpX5t2"} Sanjivy Kumaravel
