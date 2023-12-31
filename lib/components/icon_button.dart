import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/animation_widget.dart';
import 'package:tic_tac_toe/helper/audio_controller.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';
import 'package:vibration/vibration.dart';

class MyIconButton extends StatelessWidget {
  const MyIconButton({
    super.key,
    required this.onPressed,
    required this.msDelay,
    required this.iconData,
  });

  final Function onPressed;
  final int msDelay;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 32,
      right: 32,
      child: AnimationOnWidget(
        msDelay: 1200, // need to change \ get as arg
        doStateChange: true,
        child: ElevatedButton(
          onPressed: () async {
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
              const Size(48, 48),
            ),
            elevation: MaterialStateProperty.all<double>(4),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            padding:
                MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
            backgroundColor: MaterialStateProperty.all<Color>(
                Provider.of<ThemeProvider>(context, listen: true).primaryColor),
          ),
          child: Icon(
            iconData,
            color: Provider.of<ThemeProvider>(context, listen: true).bgColor,
          ),
        ),
      ),
    );
  }
}
