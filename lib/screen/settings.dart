import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/components/button.dart';
import 'package:tic_tac_toe/components/icon_button.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/components/pop_up.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/animation_widget.dart';
import 'package:tic_tac_toe/helper/navigation.dart';
import 'package:tic_tac_toe/helper/show_banner_ad.dart';
import 'package:tic_tac_toe/helper/show_interstitial_ad.dart';
import 'package:tic_tac_toe/provider/audio_provider.dart';
import 'package:tic_tac_toe/provider/login_provider.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';
import 'package:tic_tac_toe/screen/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Navigation navigation;

  BottomBannerAd ad = BottomBannerAd();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    navigation = Navigation(Navigator.of(context));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, AudioProvider, LoginProvider>(
      builder: (context, themeProvider, audioProvider, loginProvider, _) {
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
                                "Disable Game audio",
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
                                value: !audioProvider.canPlayAudio,
                                onChanged: (value) {
                                  audioProvider.setPlayAudio();
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
                          text: Platform.isIOS
                              ? "More on App Store"
                              : "More on PlayStore",
                          msDelay: 1000,
                          doStateChange: true,
                          onPressed: () {
                            String url = "";
                            if (Platform.isIOS) {
                              url =
                                  "https://apps.apple.com/us/developer/sanjivy-kumaravel/id1741498828";
                            } else {
                              url =
                                  "https://play.google.com/store/apps/dev?id=6439925551269057866";
                            }
                            launchUrl(Uri.parse(url));
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
                        loginProvider.isLoggedIn
                            ? AnimationOnWidget(
                                msDelay: 1400,
                                doStateChange: true,
                                child: Text(
                                  "Logged in as: ${loginProvider.getUserData.name}",
                                  style: TextStyle(
                                    fontSize: defaultTextSize + 2,
                                    color: themeProvider.secondaryColor,
                                  ),
                                ),
                              )
                            : Container(),
                        const VerticalSpacer(4),
                        loginProvider.isLoggedIn
                            ? MyButton(
                                text: "Logout",
                                msDelay: 1400,
                                doStateChange: true,
                                onPressed: () {
                                  loginProvider.logout();

                                  Fluttertoast.showToast(
                                    msg: "Logged out successfully",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                  );
                                },
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                MyIconButton(
                  msDelay: 1400,
                  iconData: Icons.arrow_back_ios_new_rounded,
                  onPressed: () {
                    FullScreenAd.object.show();

                    navigation.changeScreenReplacement(
                      const HomeScreen(),
                      widget,
                    );
                  },
                )
              ],
            ),
            bottomNavigationBar: ad.showBanner(),
          ),
        );
      },
    );
  }
}
