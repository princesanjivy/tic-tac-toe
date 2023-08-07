import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';

class PlayerCard extends StatelessWidget {
  const PlayerCard({
    super.key,
    required this.imageUrl,
    required this.name,
    this.showScore = false,
    this.isAsset = false,
    this.scoreValue = 0,
  });

  final String imageUrl;
  final String name;
  final bool showScore;
  final bool isAsset;
  final int scoreValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Provider.of<ThemeProvider>(context, listen: true).bgColor,
            borderRadius: BorderRadius.circular(100),
            boxShadow: shadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: isAsset
                ? Padding(
                    padding: const EdgeInsets.all(25),
                    child: Image.asset(
                      imageUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.network(
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
            color: Provider.of<ThemeProvider>(context, listen: true)
                .secondaryColor,
          ),
        ),
        const VerticalSpacer(12),
        showScore
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Provider.of<ThemeProvider>(context, listen: true)
                      .secondaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Won: $scoreValue",
                  style: TextStyle(
                    fontSize: 14,
                    color: Provider.of<ThemeProvider>(context, listen: true)
                        .bgColor,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
