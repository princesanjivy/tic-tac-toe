import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/components/button.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/audio_controller.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/provider/login_provider.dart';
import 'package:tic_tac_toe/screen/room.dart';
import 'package:vibration/vibration.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer player = AudioPlayer();
  final AudioPlayer buttonClickPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // player.stop();
    // player.setVolume(0.055);
    // player.setReleaseMode(ReleaseMode.loop);
    // player.play(AssetSource("audio/bg_music.mp3"));
  }

  @override
  void dispose() {
    super.dispose();

    // player.stop();
    // player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, loginProvider, _) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          alignment: Alignment.topRight,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextAnimator(
                    "Tic Tac Toe",
                    style: GoogleFonts.hennyPenny(
                      fontSize: 58,
                      color: primaryColor,
                    ),
                    // characterDelay: const Duration(milliseconds: 100),
                    incomingEffect:
                        WidgetTransitionEffects.incomingSlideInFromBottom(),
                    // atRestEffect: WidgetRestingEffects.wave(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const VerticalSpacer(48),
                      WidgetAnimator(
                        incomingEffect: WidgetTransitionEffects.incomingScaleUp(
                          delay: const Duration(milliseconds: 1600),
                        ),
                        atRestEffect: WidgetRestingEffects.wave(),
                        child: Text(
                          "Select mode",
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: defaultTextSize,
                          ),
                        ),
                      ),
                      const VerticalSpacer(32),
                      WidgetAnimator(
                        incomingEffect: WidgetTransitionEffects.incomingScaleUp(
                          delay: const Duration(milliseconds: 800),
                          curve: Curves.easeInOut,
                        ),
                        child: MyButton(
                          onPressed: () {
                            print("Player vs AI mode");
                            Navigation.changeScreenReplacement(
                              context,
                              const RoomScreen(),
                              widget,
                            );
                            // buttonClickPlayer
                            //     .play(AssetSource("audio/click.wav"));
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => GameRoom()));
                          },
                          text: "Single",
                        ),
                      ),
                      const VerticalSpacer(16),
                      WidgetAnimator(
                        incomingEffect: WidgetTransitionEffects.incomingScaleUp(
                          delay: const Duration(milliseconds: 1200),
                          curve: Curves.easeInOut,
                        ),
                        child: MyButton(
                          onPressed: () async {
                            User? user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              print("user is available");
                              Navigation.changeScreenReplacement(
                                context,
                                const RoomScreen(),
                                widget,
                              );
                            } else {
                              print("sign in");
                              UserCredential userCred =
                                  await loginProvider.loginWithGoogle();
                              print(userCred.user!.displayName);

                              Fluttertoast.showToast(
                                msg: "Welcome ${userCred.user!.displayName!}",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                              );
                            }
                          },
                          text: "Online",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 32,
              right: 32,
              child: WidgetAnimator(
                incomingEffect: WidgetTransitionEffects.incomingScaleUp(
                  delay: const Duration(milliseconds: 1600),
                  curve: Curves.easeInOut,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Vibration.vibrate(duration: 80, amplitude: 120);
                    AudioController.buttonClick("audio/click2.ogg");

                    print("show menu card");

                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: bgColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: Text(
                              "Info",
                              style: TextStyle(
                                fontSize: defaultTextSize + 6,
                                color: primaryColor,
                              ),
                            ),
                            content: SizedBox(
                              height: 100,
                              child: Column(
                                children: [
                                  Text(
                                    "App settings will appear here",
                                    style: TextStyle(
                                      fontSize: defaultTextSize,
                                      color: secondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                  child: Text(
                    "i",
                    style: TextStyle(
                      fontSize: defaultTextSize,
                      color: bgColor,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
