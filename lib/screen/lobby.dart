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
import 'package:tic_tac_toe/screen/room.dart';
import 'package:vibration/vibration.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({
    super.key,
    required this.roomData,
    required this.isRoomOwner,
  });

  final RoomData roomData;
  final bool isRoomOwner;

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late Navigation navigation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    navigation = Navigation(Navigator.of(context));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, _) {
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
                                  "${widget.roomData.code}",
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
                                    "Tic Tac Toe Online room code is : ${widget.roomData.code}",
                                  );
                                },
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all<Size>(
                                    const Size(48, 48),
                                  ),
                                  elevation:
                                      MaterialStateProperty.all<double>(4),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
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
                          imageUrl: loginProvider.getUserData.displayPicture,
                          name: loginProvider.getUserData.name,
                        ),
                        Text(
                          "vs",
                          style: GoogleFonts.hennyPenny(
                            fontSize: defaultTextSize,
                            color: primaryColor,
                          ),
                        ),
                        widget.roomData.players.length == 2
                            ? FutureBuilder<Player>(
                                future: loginProvider.getUserById(widget
                                    .roomData
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
                    widget.roomData.players.length == 2
                        ? widget.isRoomOwner
                            ? Container()
                            : Text(
                                "Wait for Player1 to start the game",
                                style: TextStyle(
                                  fontSize: defaultTextSize - 4,
                                  color: secondaryColor,
                                ),
                              )
                        : Text(
                            "Waiting for player to join...",
                            style: TextStyle(
                              fontSize: defaultTextSize - 4,
                              color: secondaryColor,
                            ),
                          ),
                    widget.roomData.players.length == 2
                        ? !widget.isRoomOwner
                            ? const VerticalSpacer(8)
                            : Container()
                        : const VerticalSpacer(8),

                    Consumer<RoomProvider>(builder: (context, roomProvider, _) {
                      return MyButton(
                        text: widget.roomData.players.length == 2
                            ? widget.isRoomOwner
                                ? "Start"
                                : "Waiting..."
                            : "Waiting...",
                        onPressed: () {
                          if (widget.isRoomOwner) {
                            roomProvider.isStarted(true, widget.roomData.code);
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
                            widget.roomData.players.length == 2 ? false : true,
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

                      showDialog(
                          context: context,
                          builder: (context) {
                            RoomProvider roomProvider =
                                Provider.of<RoomProvider>(context,
                                    listen: false);

                            return AlertDialog(
                              backgroundColor: bgColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title: const Text("Are you sure want to leave?"),
                              content: SizedBox(
                                height: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Leave room!"),
                                  ],
                                ),
                              ),
                              actions: [
                                MyButton(
                                  text: "Yes",
                                  onPressed: () {
                                    roomProvider.leaveRoom(
                                      widget.roomData,
                                      widget.isRoomOwner,
                                    );
                                    // TODO: navigate back screen only when it is deleted!
                                    Navigation.goBack(context);
                                    navigation.changeScreenReplacement(
                                      const RoomScreen(),
                                      widget,
                                    );
                                  },
                                ),
                              ],
                            );
                          });
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
  }
}

// {"chose": "O", "id": "mpy0Iz7hPWMGQOVYOv15y8o3VlI3"} Prince Sanjivy
// {"chose": "O", "id": "acokUiqN5nXAnL9axIn36PRpX5t2"} Sanjivy Kumaravel
