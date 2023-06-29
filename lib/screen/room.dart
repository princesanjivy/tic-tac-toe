import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/components/button.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/audio_controller.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/model/player.dart';
import 'package:tic_tac_toe/provider/room_provider.dart';
import 'package:tic_tac_toe/screen/home.dart';
import 'package:vibration/vibration.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Consumer<RoomProvider>(builder: (context, roomProvider, _) {
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
                        // controller: TextEditingController()..text = "123456",
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
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
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
                    child: MyButton(
                      onPressed: () {
                        print("Pressed");
                      },
                      text: "Join",
                    ),
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
                    child: MyButton(
                      onPressed: () async {
                        print("Proceed to room creation & wait in lobby");

                        Player player = Player("Sanjivy", "123456");

                        print(player.playerId);

                        /// for testing inserting dummy values
                        roomProvider.createRoom(player);
                        // Navigation.changeScreenReplacement(
                        //   context,
                        //   const LobbyScreen(),
                        //   widget,
                        // );
                      },
                      text: "Create room",
                    ),
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
    });
  }
}
