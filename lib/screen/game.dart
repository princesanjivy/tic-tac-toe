import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe/components/my_spacer.dart';
import 'package:tic_tac_toe/components/player_card.dart';
import 'package:tic_tac_toe/constants.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<int> corners = [0, 3, 12, 15];
  Map<int, BorderRadiusGeometry> borders = {
    0: const BorderRadius.only(
      topLeft: Radius.circular(16),
    ),
    3: const BorderRadius.only(
      topRight: Radius.circular(16),
    ),
    12: const BorderRadius.only(
      bottomLeft: Radius.circular(16),
    ),
    15: const BorderRadius.only(
      bottomRight: Radius.circular(16),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PlayerCard(
                  imageUrl: imageUrl,
                  name: "You",
                  showScore: true,
                  scoreValue: 2,
                ),
                Text(
                  "Round\n1",
                  style: GoogleFonts.hennyPenny(
                    fontSize: defaultTextSize - 2,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                PlayerCard(
                  imageUrl: imageUrl,
                  name: "Opponent",
                  showScore: true,
                  scoreValue: 0,
                ),
              ],
            ),
            const VerticalSpacer(16),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Container(
                // width: 300,
                // height: 300,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    // childAspectRatio: 1,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: index == 0 ? Colors.green : bgColor,
                        border: Border.all(
                          color: primaryColor,
                          // width: 2,
                        ),
                        borderRadius:
                            corners.contains(index) ? borders[index] : null,
                      ),
                      child: Center(
                        child: Text(
                          index % 2 == 0 ? "X" : "O",
                          style: GoogleFonts.hennyPenny(
                            fontSize: 42 - 8,
                            color: index == 0 ? bgColor : primaryColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const VerticalSpacer(4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Your turn",
                style: TextStyle(
                  fontSize: defaultTextSize,
                  color: bgColor,
                ),
              ),
            ),
            const VerticalSpacer(8),
            Text(
              "X",
              style: GoogleFonts.hennyPenny(
                fontSize: 32,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
