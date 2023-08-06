import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/components/button.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class MyPopUp extends StatelessWidget {
  const MyPopUp({
    super.key,
    required this.title,
    required this.description,
    required this.button1Text,
    required this.button2Text,
    required this.button1OnPressed,
    required this.button2OnPressed,
  });

  final String title, description, button1Text, button2Text;
  final VoidCallback button1OnPressed, button2OnPressed;

  @override
  Widget build(BuildContext context) {
    return WidgetAnimator(
      incomingEffect: WidgetTransitionEffects.incomingScaleUp(
        delay: const Duration(microseconds: 500),
        curve: Curves.easeInOut,
      ),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return AlertDialog(
            backgroundColor: themeProvider.bgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: defaultTextSize + 6,
                color: themeProvider.primaryColor,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  description,
                  style: TextStyle(
                    fontSize: defaultTextSize + 3,
                    color: themeProvider.secondaryColor,
                  ),
                ),
                const VerticalSpacer(16),
                MyButton(
                  text: button1Text,
                  onPressed: button1OnPressed,
                ),
                const VerticalSpacer(8),
                MyButton(
                  text: button2Text,
                  onPressed: button2OnPressed,
                  invertColor: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PopUp {
  final String title;
  final String description;
  final String button1Text;
  final String button2Text;
  final bool barrierDismissible;
  final VoidCallback button1OnPressed, button2OnPressed;

  PopUp.show(
    BuildContext context, {
    required this.title,
    required this.description,
    required this.button1Text,
    required this.button2Text,
    required this.barrierDismissible,
    required this.button1OnPressed,
    required this.button2OnPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => MyPopUp(
        title: title,
        description: description,
        button1Text: button1Text,
        button2Text: button2Text,
        button1OnPressed: button1OnPressed,
        button2OnPressed: button2OnPressed,
      ),
    );
  }
}
