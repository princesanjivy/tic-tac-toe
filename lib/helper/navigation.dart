import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Navigation {
  late final NavigatorState _navigatorState;

  Navigation(this._navigatorState);

  Future changeScreenReplacement(Widget screen, Widget currentScreen) {
    return _navigatorState.pushReplacement(
      PageTransition(
        child: screen,
        type: PageTransitionType.rightToLeftWithFade,
        childCurrent: currentScreen,
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void goBack(BuildContext context) {
    return Navigator.pop(context);
  }
}
