import 'package:flutter/material.dart';
import 'package:tic_tac_toe/helper/game.dart' as helper;

class BoardDesign {
  List<int> corners = [];
  Map<int, BorderRadiusGeometry> borders = {};

  BoardDesign(this.corners, this.borders);
}

BoardDesign boardDesign(List board) {
  Map<int, BorderRadiusGeometry> borders = {};

  List borderRadius = [
    const BorderRadius.only(
      topLeft: Radius.circular(16),
    ),
    const BorderRadius.only(
      topRight: Radius.circular(16),
    ),
    const BorderRadius.only(
      bottomLeft: Radius.circular(16),
    ),
    const BorderRadius.only(
      bottomRight: Radius.circular(16),
    ),
  ];
  List<int> corners = helper.findCornerPositions(board.length);
  for (int i = 0; i < corners.length; i++) {
    borders.addAll({corners[i]: borderRadius[i]});
  }

  return BoardDesign(corners, borders);
}
