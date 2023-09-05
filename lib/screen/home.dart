import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/components/button.dart';
import 'package:tic_tac_toe/components/icon_button.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/animation_widget.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/provider/login_provider.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';
import 'package:tic_tac_toe/screen/room.dart';
import 'package:tic_tac_toe/screen/settings.dart';
import 'package:tic_tac_toe/screen/single_mode.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer player = AudioPlayer();
  final AudioPlayer buttonClickPlayer = AudioPlayer();

  late Navigation navigation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    navigation = Navigation(Navigator.of(context));
  }

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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            backgroundColor: themeProvider.bgColor,
            body: Stack(
              alignment: Alignment.topRight,
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Text(
                      //   "Tic Tac Toe",
                      //   style: GoogleFonts.hennyPenny(
                      //     fontSize: 58,
                      //     color: themeProvider.primaryColor,
                      //   ),
                      // ),
                      TextAnimator(
                        "Tic Tac Toe",
                        style: GoogleFonts.hennyPenny(
                          fontSize: 58,
                          color: themeProvider.primaryColor,
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
                          AnimationOnWidget(
                            hasRestEffect: true,
                            msDelay: 1600,
                            child: Text(
                              "Select mode",
                              style: TextStyle(
                                color: themeProvider.secondaryColor,
                                fontSize: defaultTextSize,
                              ),
                            ),
                          ),
                          const VerticalSpacer(32),
                          MyButton(
                            msDelay: 800,
                            doStateChange: true,
                            onPressed: () {
                              print("Player vs AI mode");
                              navigation.changeScreenReplacement(
                                const SingleModeScreen(),
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
                          const VerticalSpacer(16),
                          Consumer<LoginProvider>(
                            builder: (context, loginProvider, _) {
                              return MyButton(
                                doStateChange: true,
                                msDelay: 1200,
                                onPressed: () async {
                                  User? user =
                                      FirebaseAuth.instance.currentUser;
                                  if (user != null) {
                                    print("user is available");
                                    navigation.changeScreenReplacement(
                                      const RoomScreen(),
                                      widget,
                                    );
                                  } else {
                                    print("sign in");
                                    UserCredential userCred =
                                        await loginProvider.loginWithGoogle();

                                    Fluttertoast.showToast(
                                      msg:
                                          "Welcome ${userCred.user!.displayName!}",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                    );
                                  }
                                },
                                text: "Online",
                                showLoading: loginProvider.loading,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                MyIconButton(
                  msDelay: 1600,
                  iconData: Icons.settings,
                  onPressed: () {
                    navigation.changeScreenReplacement(
                      const SettingsPage(),
                      widget,
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
