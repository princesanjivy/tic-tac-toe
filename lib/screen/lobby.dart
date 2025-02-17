import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tic_tac_toe/components/button.dart';
import 'package:tic_tac_toe/components/icon_button.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/components/player_card.dart';
import 'package:tic_tac_toe/components/pop_up.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/animation_widget.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/helper/show_banner_ad.dart';
import 'package:tic_tac_toe/model/player.dart';
import 'package:tic_tac_toe/model/room.dart';
import 'package:tic_tac_toe/provider/game_provider.dart';
import 'package:tic_tac_toe/provider/login_provider.dart';
import 'package:tic_tac_toe/provider/room_provider.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';
import 'package:tic_tac_toe/screen/room.dart';

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
  late RoomProvider roomProvider;

  BottomBannerAd ad = BottomBannerAd();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    navigation = Navigation(Navigator.of(context));
    roomProvider = Provider.of<RoomProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    double width = kIsWeb ? 600 : MediaQuery.of(context).size.width;

    return Consumer2<LoginProvider, ThemeProvider>(
      builder: (context, loginProvider, themeProvider, _) {
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
                      msDelay: 400,
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Container(
                          width: width,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(borderRadius),
                            border: Border.all(
                              color: themeProvider.primaryColor,
                              width: 2,
                            ),
                            color: themeProvider.bgColor,
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
                                      color: themeProvider.secondaryColor,
                                    ),
                                  ),
                                  const VerticalSpacer(12),
                                  Text(
                                    "${widget.roomData.code}",
                                    style: GoogleFonts.hennyPenny(
                                      fontSize: 24,
                                      color: themeProvider.primaryColor,
                                    ),
                                  ),
                                ],
                              ),

                              /// share button, show copy button in web
                              Positioned(
                                top: 20,
                                right: 10,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (kIsWeb) {
                                      FlutterClipboard.copy(
                                        "Tic Tac Toe Online room code is : ${widget.roomData.code}, vist $gameLinkWeb and play.\n"
                                        "Want to play in Android instead?, visit the link to download: ${Platform.isIOS ? gameLinkIos: gameLinkAndroid}.",
                                      );

                                      Fluttertoast.showToast(
                                        msg: "Room code copied",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                      );
                                    } else {
                                      Share.share(
                                          "Tic Tac Toe Online room code is : ${widget.roomData.code}.\n"
                                          "Don't have the game, visit the link to download: ${Platform.isIOS ? gameLinkIos: gameLinkAndroid}.");
                                    }
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
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.all(0)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            themeProvider.primaryColor),
                                  ),
                                  child: Icon(
                                    kIsWeb ? Icons.copy : Icons.share_rounded,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    const VerticalSpacer(32),

                    /// players vs opponent display cards
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AnimationOnWidget(
                          msDelay: 800,
                          child: PlayerCard(
                            imageUrl: loginProvider.getUserData.displayPicture,
                            name: loginProvider.getUserData.name,
                          ),
                        ),
                        AnimationOnWidget(
                          msDelay: 1200,
                          child: Text(
                            "vs",
                            style: GoogleFonts.hennyPenny(
                              fontSize: defaultTextSize,
                              color: themeProvider.primaryColor,
                            ),
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
                                        color: themeProvider.bgColor);
                                  }
                                  return AnimationOnWidget(
                                    msDelay: 800,
                                    child: PlayerCard(
                                      imageUrl: snapshot.data!.displayPicture,
                                      name: snapshot.data!.name,
                                    ),
                                  );
                                },
                              )
                            : AnimationOnWidget(
                                msDelay: 800,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: themeProvider.bgColor,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        boxShadow: shadow,
                                      ),
                                    ),
                                    const VerticalSpacer(16),
                                    Text(
                                      "Waiting for\nopponent",
                                      style: TextStyle(
                                        fontSize: defaultTextSize,
                                        color: themeProvider.secondaryColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
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
                                  color: themeProvider.secondaryColor,
                                ),
                              )
                        : AnimationOnWidget(
                            msDelay: 1600,
                            child: Text(
                              "Waiting for player to join...",
                              style: TextStyle(
                                fontSize: defaultTextSize - 4,
                                color: themeProvider.secondaryColor,
                              ),
                            ),
                          ),
                    widget.roomData.players.length == 2
                        ? !widget.isRoomOwner
                            ? const VerticalSpacer(8)
                            : Container()
                        : const VerticalSpacer(8),

                    Consumer2<RoomProvider, GameProvider>(
                        builder: (context, roomProvider, gameProvider, _) {
                      print(widget.roomData.players.length);
                      return MyButton(
                        msDelay: 1600,
                        doStateChange: true,
                        text: widget.roomData.players.length == 2
                            ? widget.isRoomOwner
                                ? "Start"
                                : "Waiting..."
                            : "Waiting...",
                        onPressed: () {
                          if (widget.isRoomOwner) {
                            if (widget.roomData.players[0].playerId ==
                                widget.roomData.players[1].playerId) {
                              Fluttertoast.showToast(
                                msg: "Looks like you're play against yourself",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                              );
                            } else {
                              roomProvider.isStarted(
                                  true, widget.roomData.code);
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: "You can't start the game",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                            );
                          }
                        },
                        showLoading:
                            widget.roomData.players.length == 2 ? false : true,
                      );
                    }),
                  ],
                ),
              ),
              MyIconButton(
                  onPressed: () {
                    PopUp.show(
                      context,
                      title: "Warning",
                      description: "Are you sure want to leave?",
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
                  msDelay: 2000,
                  iconData: Icons.arrow_back_ios_new_rounded),
            ],
          ),
          bottomNavigationBar: ad.showBanner(),
        );
      },
    );
  }
}

// {"chose": "O", "id": "mpy0Iz7hPWMGQOVYOv15y8o3VlI3"} Prince Sanjivy
// {"chose": "O", "id": "acokUiqN5nXAnL9axIn36PRpX5t2"} Sanjivy Kumaravel
