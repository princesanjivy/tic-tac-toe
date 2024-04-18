import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/components/button.dart';
import 'package:tic_tac_toe/components/icon_button.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/components/pop_up.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/animation_widget.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';
import 'package:tic_tac_toe/screen/settings.dart';
import 'package:tic_tac_toe/screen/single_mode.dart';
import 'package:url_launcher/url_launcher.dart';
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
                              PopUp.show(
                                context,
                                title: "Select mode",
                                description:
                                    "Do you want to play against AI or with another Player?",
                                button1Text: "AI",
                                button2Text: "Player",
                                barrierDismissible: true,
                                button1OnPressed: () {
                                  navigation.changeScreenReplacement(
                                    const SingleModeScreen(
                                      twoPlayerMode: false,
                                    ),
                                    widget,
                                  );
                                },
                                button2OnPressed: () {
                                  navigation.changeScreenReplacement(
                                    const SingleModeScreen(
                                      twoPlayerMode: true,
                                    ),
                                    widget,
                                  );
                                },
                              );
                            },
                            text: "Single",
                          ),
                          const VerticalSpacer(16),
                          MyButton(
                            doStateChange: true,
                            msDelay: 1200,
                            onPressed: () {
                              PopUp.show(
                                context,
                                title: "Info",
                                description:
                                    "To play the game Online with other players, please download the same app from PlayStore."
                                    "\n\nThe source code of the online-mode version can be found under the `master` of TicTacToe repo on Github.",
                                button1Text: "Visit PlayStore",
                                button2Text: "Close",
                                barrierDismissible: false,
                                button1OnPressed: () async {
                                  launchUrl(Uri.parse(gameLinkAndroid));
                                },
                                button2OnPressed: () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                            text: "Online",
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
