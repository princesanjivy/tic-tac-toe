import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/audio_controller.dart';
import 'package:vibration/vibration.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.showLoading = false,
  });

  final String text;
  final Function onPressed;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: showLoading
          ? null
          : () {
              Vibration.vibrate(duration: 80, amplitude: 120);
              AudioController.buttonClick("audio/click2.ogg");
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
        backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
      ),
      child: showLoading
          ? CircularProgressIndicator(
              color: bgColor,
              strokeWidth: 2,
            )
          : Text(
              text,
              style: TextStyle(
                fontSize: defaultTextSize,
                color: bgColor,
                letterSpacing: 1,
              ),
            ),
    );
  }
}
