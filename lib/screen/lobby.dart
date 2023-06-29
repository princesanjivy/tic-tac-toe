import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe/components/button.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/components/player_card.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/audio_controller.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/screen/game.dart';
import 'package:tic_tac_toe/screen/room.dart';
import 'package:vibration/vibration.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  @override
  Widget build(BuildContext context) {
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
                              "123456",
                              style: GoogleFonts.hennyPenny(
                                fontSize: 24,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 20,
                          right: 10,
                          child: ElevatedButton(
                            onPressed: () {
                              print("Open share dialog");
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PlayerCard(
                      imageUrl: imageUrl,
                      name: "You",
                    ),
                    Text(
                      "vs",
                      style: GoogleFonts.hennyPenny(
                        fontSize: defaultTextSize,
                        color: primaryColor,
                      ),
                    ),
                    PlayerCard(
                      imageUrl: imageUrl,
                      name: "Opponent",
                    ),
                  ],
                ),
                const VerticalSpacer(84),
                MyButton(
                  text: "Waiting...",
                  onPressed: () {
                    Navigation.changeScreenReplacement(
                      context,
                      const GameScreen(),
                      widget,
                    );
                  },
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
  }
}
