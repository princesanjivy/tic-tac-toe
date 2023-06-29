import 'package:flutter/material.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/constants.dart';

class PlayerCard extends StatelessWidget {
  const PlayerCard({
    super.key,
    required this.imageUrl,
    required this.name,
    this.showScore = false,
    this.scoreValue = 0,
  });

  final String imageUrl;
  final String name;
  final bool showScore;
  final int scoreValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(100),
            boxShadow: shadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const VerticalSpacer(16),
        Text(
          name,
          style: TextStyle(
            fontSize: defaultTextSize,
            color: secondaryColor,
          ),
        ),
        const VerticalSpacer(12),
        showScore
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Won: $scoreValue",
                  style: TextStyle(
                    fontSize: 14,
                    color: bgColor,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
