import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/components/button.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/components/pop_up.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/animation_widget.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/provider/room_provider.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';
import 'package:tic_tac_toe/provider/tictacit_provider.dart';
import 'package:tic_tac_toe/screen/room.dart';
import 'package:tic_tac_toe/screen/settings.dart';
import 'package:tic_tac_toe/screen/single_mode.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../components/icon_button.dart';

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
    return Consumer2<ThemeProvider, TicTacItProvider>(
      builder: (context, themeProvider, t, _) {
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
                              "Welcome ${t.player.name}! \n\nSelect mode",
                              textAlign: TextAlign.center,
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
                                    const SingleModeScreen(twoPlayerMode: true),
                                    widget,
                                  );
                                },
                              );
                            },
                            text: "Play Now",
                          ),
                          const VerticalSpacer(16),
                          Consumer<RoomProvider>(
                            builder: (context, room, _) {
                              return MyButton(
                                doStateChange: true,
                                msDelay: 1200,
                                onPressed: () async {
                                  room.connect(t.player.id!);
                                  navigation.changeScreenReplacement(
                                    const RoomScreen(),
                                    widget,
                                  );
                                },
                                text: "Online",
                                showLoading: room.isConnecting,
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 84, right: 32),
                  child: AnimationOnWidget(
                    msDelay: 1400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: themeProvider.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            spacing: 4,
                            children: [
                              Image.asset("assets/images/coin.png", width: 24),
                              Text(
                                "${t.coins}",
                                style: TextStyle(
                                  color: themeProvider.bgColor,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
