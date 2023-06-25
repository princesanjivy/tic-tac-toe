import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Navigation {
  static Future changeScreen(
      BuildContext context, Widget screen, Widget currentScreen) {
    return Navigator.push(
      context,
      PageTransition(
        child: screen,
        type: PageTransitionType.rightToLeftWithFade,
        childCurrent: currentScreen,
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  static Future changeScreenReplacement(
      BuildContext context, Widget screen, Widget currentScreen) {
    return Navigator.pushReplacement(
      context,
      PageTransition(
        child: screen,
        type: PageTransitionType.rightToLeftWithFade,
        childCurrent: currentScreen,
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  static goBack(BuildContext context) {
    return Navigator.pop(context);
  }
}
