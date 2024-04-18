import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/components/icon_button.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/components/player_card.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/game.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/model/symbol.dart';
import 'package:tic_tac_toe/provider/single_mode_provider.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';
import 'package:tic_tac_toe/screen/home.dart';
import 'package:vibration/vibration.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class SingleModeScreen extends StatefulWidget {
  const SingleModeScreen({super.key, required this.twoPlayerMode});

  final bool twoPlayerMode;

  @override
  State<SingleModeScreen> createState() => SingleModeScreenState();
}

class SingleModeScreenState extends State<SingleModeScreen> {
  late Navigation navigation;

  @override
  void initState() {
    super.initState();

    initProvider();
  }

  void initProvider() {
    Provider.of<SingleModeProvider>(context, listen: false)
        .init(context, widget, widget.twoPlayerMode);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    navigation = Navigation(Navigator.of(context));
  }

  @override
  Widget build(BuildContext context) {
    SingleModeProvider provider =
        Provider.of<SingleModeProvider>(context, listen: true);

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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PlayAnimationOnWidget(
                        msDelay: 400,
                        child: PlayerCard(
                          imageUrl: "assets/images/user.png",
                          name: "You (${provider.playerChose})",
                          isAsset: true,
                          showScore: true,
                          scoreValue: provider
                              .scores[PlaySymbol.inNum(provider.playerChose)]!,
                        ),
                      ),
                      PlayAnimationOnWidget(
                        msDelay: 1200,
                        child: Text(
                          "Round\n${provider.round}",
                          style: GoogleFonts.hennyPenny(
                            fontSize: defaultTextSize - 2,
                            color: themeProvider.primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      PlayAnimationOnWidget(
                        msDelay: 400,
                        child: PlayerCard(
                          imageUrl: widget.twoPlayerMode
                              ? "assets/images/user.png"
                              : "assets/images/ai.png",
                          name:
                              "${widget.twoPlayerMode ? "Player" : "AI"} (${provider.aiChose})",
                          isAsset: true,
                          showScore: true,
                          scoreValue: provider
                              .scores[PlaySymbol.inNum(provider.aiChose)]!,
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpacer(16),
                  PlayAnimationOnWidget(
                    useIncomingEffect: true,
                    incomingEffect: WidgetTransitionEffects.incomingScaleDown(
                      delay: const Duration(milliseconds: 800),
                      curve: Curves.fastOutSlowIn,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Container(
                        width: kIsWeb ? 500 : null,
                        height: kIsWeb ? 500 : null,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: themeProvider.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: GridView.builder(
                          padding: const EdgeInsets.all(0),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: getBoardSize(provider.board),
                            mainAxisSpacing: 1,
                            crossAxisSpacing: 1,
                            // childAspectRatio: 1,
                          ),
                          itemCount: provider.board.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (!kIsWeb) {
                                  Vibration.vibrate(
                                      duration: 80, amplitude: 120);
                                }
                                if (widget.twoPlayerMode) {
                                  if (provider.board[index] == 0) {
                                    print(provider.board);
                                    provider.board[index] =
                                        PlaySymbol.inNum(provider.turn);
                                    provider.turn =
                                        (provider.turn == PlaySymbol.x
                                            ? PlaySymbol.o
                                            : PlaySymbol.x);

                                    provider.validate();
                                  }
                                } else {
                                  if (provider.board[index] == 0 &&
                                      provider.turn == provider.playerChose) {
                                    provider.board[index] =
                                        PlaySymbol.inNum(provider.turn);
                                    provider.turn =
                                        (provider.turn == PlaySymbol.x
                                            ? PlaySymbol.o
                                            : PlaySymbol.x);

                                    provider.aiMove(provider.turn);
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      provider.result.positions.contains(index)
                                          ? Colors.deepOrange.withOpacity(0.8)
                                          : themeProvider.bgColor,
                                  border: Border.all(
                                    color: themeProvider.primaryColor,
                                    // width: 2,
                                  ),
                                  borderRadius: provider.corners.contains(index)
                                      ? provider.borders[index]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    provider.board[index] == PlaySymbol.xInt
                                        ? PlaySymbol.x
                                        : provider.board[index] ==
                                                PlaySymbol.oInt
                                            ? PlaySymbol.o
                                            : "",
                                    style: GoogleFonts.hennyPenny(
                                      fontSize: 42 - 8,
                                      color: provider.result.positions
                                              .contains(index)
                                          ? themeProvider.bgColor
                                          : themeProvider.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const VerticalSpacer(4),
                  PlayAnimationOnWidget(
                    msDelay: 1200,
                    hasRestEffect: true,
                    incomingEffect: WidgetTransitionEffects.incomingScaleUp(
                      delay: const Duration(milliseconds: 1200),
                      curve: Curves.easeInOut,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: themeProvider.secondaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        (provider.turn == provider.playerChose)
                            ? "Your turn"
                            : widget.twoPlayerMode
                                ? "Player turn"
                                : "AI turn",
                        style: TextStyle(
                          fontSize: defaultTextSize,
                          color: themeProvider.bgColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            MyIconButton(
              msDelay: 1200,
              iconData: Icons.arrow_back_ios_new_rounded,
              onPressed: () {
                navigation.changeScreenReplacement(
                  const HomeScreen(),
                  widget,
                );
              },
            )
          ],
        ),
      );
    });
  }
}

class PlayAnimationOnWidget extends StatefulWidget {
  final Widget child;
  final int? msDelay;
  final bool useIncomingEffect, hasRestEffect;
  final WidgetTransitionEffects? incomingEffect;

  const PlayAnimationOnWidget({
    super.key,
    required this.child,
    this.msDelay,
    this.useIncomingEffect = false,
    this.incomingEffect,
    this.hasRestEffect = false,
  });

  @override
  State<PlayAnimationOnWidget> createState() => _PlayAnimationOnWidgetState();
}

class _PlayAnimationOnWidgetState extends State<PlayAnimationOnWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SingleModeProvider>(builder: (context, provider, _) {
      return WidgetAnimator(
        incomingEffect: widget.useIncomingEffect
            ? widget.incomingEffect
            : WidgetTransitionEffects.incomingScaleUp(
                delay: Duration(milliseconds: widget.msDelay!),
                curve: Curves.easeInOut,
              ),
        atRestEffect: widget.hasRestEffect ? WidgetRestingEffects.wave() : null,
        doStateChange: provider.doStateChange,
        child: widget.child,
      );
    });
  }
}
