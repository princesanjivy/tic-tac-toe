import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/components/button.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/components/pop_up.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/animation_widget.dart';
import 'package:tic_tac_toe/helper/audio_controller.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/provider/login_provider.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';
import 'package:tic_tac_toe/screen/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
                  child: Padding(
                    padding: const EdgeInsets.only(left: 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimationOnWidget(
                          useIncomingEffect: true,
                          incomingEffect:
                              WidgetTransitionEffects.incomingSlideInFromTop(
                            delay: const Duration(milliseconds: 400),
                            curve: Curves.fastOutSlowIn,
                          ),
                          doStateChange: true,
                          child: Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: 48,
                              color: themeProvider.primaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const VerticalSpacer(36),
                        AnimationOnWidget(
                          msDelay: 600,
                          doStateChange: true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Game audio",
                                style: TextStyle(
                                  fontSize: defaultTextSize + 2,
                                  color: themeProvider.secondaryColor,
                                ),
                              ),
                              const HorizontalSpacer(8),
                              Switch(
                                activeColor: themeProvider.primaryColor,
                                activeTrackColor:
                                    themeProvider.primaryColor.withOpacity(0.5),
                                inactiveThumbColor: themeProvider.primaryColor,
                                inactiveTrackColor:
                                    themeProvider.primaryColor.withOpacity(0.5),
                                value: !themeProvider.isLightTheme,
                                onChanged: (value) {
                                  themeProvider.changeTheme();
                                },
                              ),
                            ],
                          ),
                        ),
                        AnimationOnWidget(
                          msDelay: 800,
                          doStateChange: true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Set dark theme",
                                style: TextStyle(
                                  fontSize: defaultTextSize + 2,
                                  color: themeProvider.secondaryColor,
                                ),
                              ),
                              const HorizontalSpacer(8),
                              Switch(
                                activeColor: themeProvider.primaryColor,
                                activeTrackColor:
                                    themeProvider.primaryColor.withOpacity(0.5),
                                inactiveThumbColor: themeProvider.primaryColor,
                                inactiveTrackColor:
                                    themeProvider.primaryColor.withOpacity(0.5),
                                value: !themeProvider.isLightTheme,
                                onChanged: (value) {
                                  themeProvider.changeTheme();
                                },
                              ),
                            ],
                          ),
                        ),
                        const VerticalSpacer(16),
                        MyButton(
                          text: "More apps on PlayStore",
                          msDelay: 1000,
                          doStateChange: true,
                          onPressed: () {
                            print("ok");
                            launchUrl(
                              Uri.parse(
                                  "https://play.google.com/store/apps/dev?id=6439925551269057866"),
                            );
                          },
                        ),
                        const VerticalSpacer(26),
                        MyButton(
                          text: "Game credits",
                          msDelay: 1200,
                          doStateChange: true,
                          invertColor: true,
                          onPressed: () {
                            PopUp.show(
                              context,
                              title: "Game credits",
                              description:
                                  "Designed & developed by Sanjivy for \nprinceappstudio.in",
                              button1Text: "Know more",
                              button2Text: "Close",
                              barrierDismissible: false,
                              button1OnPressed: () async {
                                launchUrl(Uri.parse(
                                    "https://linktr.ee/princesanjivy"));
                              },
                              button2OnPressed: () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                        const VerticalSpacer(56),
                        MyButton(
                          text: "Logout",
                          msDelay: 1400,
                          doStateChange: true,
                          onPressed: () {
                            LoginProvider loginProvider =
                                Provider.of<LoginProvider>(context,
                                    listen: false);

                            loginProvider.logout();

                            Fluttertoast.showToast(
                              msg: "Logged out successfully",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 32,
                  right: 32,
                  child: AnimationOnWidget(
                    msDelay: 1400,
                    doStateChange: true,
                    child: ElevatedButton(
                      onPressed: () {
                        Vibration.vibrate(duration: 80, amplitude: 120);
                        AudioController.buttonClick("audio/click2.ogg");

                        // Navigation.goBack(context);
                        navigation.changeScreenReplacement(
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
                        backgroundColor: MaterialStateProperty.all<Color>(
                            themeProvider.primaryColor),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded, // TODO: temp icon
                        color: themeProvider.bgColor,
                      ),
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
