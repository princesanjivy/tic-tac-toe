import 'package:flutter/material.dart';

// Color primaryColor = const Color(0xFF404B47);
// Color secondaryColor = const Color(0xFFCB974E);
// Color bgColor = Colors.white;

// Color primaryColor = const Color(0xFFB95300);
// Color secondaryColor = const Color(0xFFF39C11);
// Color bgColor = const Color(0xFFFBE5A9);
// Color winColor = const Color(0xFF00FF7F);

double defaultTextSize = 18;
double borderRadius = 12;

int msAnimationDelay = 150;

String imageUrl =
    "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80";
String roomPath = "/room/";
String gameLinkAndroid =
        "https://play.google.com/store/apps/details?id=com.princeappstudio.tic_tac_toe",
    gameLinkWeb = "https://tictactoe.princeappstudio.in";
String gameLinkIos = "https://apps.apple.com/us/app/tic-tac-toe-online-2player/id6740833110";

List<BoxShadow> shadow = [
  BoxShadow(
    color: Colors.grey.withOpacity(0.8),
    blurRadius: 8,
    offset: const Offset(0, 2),
    // blurStyle: BlurStyle.outer,
  ),
];

/// Test Ad ids
const String bannerId1 = "ca-app-pub-3940256099942544/6300978111";
const String bannerId2 = "ca-app-pub-3940256099942544/6300978111";
const String interstitialId1 = "ca-app-pub-3940256099942544/1033173712";
const String interstitialId2 = "ca-app-pub-3940256099942544/1033173712";
