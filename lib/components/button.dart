import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/animation_widget.dart';
import 'package:tic_tac_toe/helper/audio_controller.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';
import 'package:vibration/vibration.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.showLoading = false,
    this.invertColor = false,
    this.canAnimate = true,
    this.doStateChange = false,
    this.hasRestEffect = false,
    this.msDelay,
  });

  final String text;
  final Function onPressed;
  final bool showLoading;
  final bool invertColor;
  final bool canAnimate;
  final int? msDelay;
  final bool? doStateChange;
  final bool? hasRestEffect;

  @override
  Widget build(BuildContext context) {
    double width = kIsWeb ? 400 : MediaQuery.of(context).size.width;

    Widget buttonChild = ElevatedButton(
      onPressed: showLoading
          ? null
          : () async {
              if (!kIsWeb) {
                Vibration.vibrate(duration: 80, amplitude: 120);
              }
              AudioController audioController = AudioController();
              audioController.buttonClick(context);
              await Future.delayed(Duration(milliseconds: msAnimationDelay));
              onPressed();
            },
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(
          Size(width / 1.6, 48),
        ),
        elevation: MaterialStateProperty.all<double>(4),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(!invertColor
            ? Provider.of<ThemeProvider>(context, listen: true).primaryColor
            : Provider.of<ThemeProvider>(context, listen: true).bgColor),
      ),
      child: showLoading
          ? CircularProgressIndicator(
              color: Provider.of<ThemeProvider>(context, listen: true).bgColor,
              strokeWidth: 2,
            )
          : Text(
              text,
              style: TextStyle(
                fontSize: defaultTextSize,
                color: !invertColor
                    ? Provider.of<ThemeProvider>(context, listen: true).bgColor
                    : Provider.of<ThemeProvider>(context, listen: true)
                        .primaryColor,
                letterSpacing: 1,
              ),
            ),
    );

    return canAnimate
        ? AnimationOnWidget(
            msDelay: msDelay,
            doStateChange: doStateChange,
            hasRestEffect: hasRestEffect!,
            child: buttonChild,
          )
        : buttonChild;
  }
}
