import 'dart:math';

int getBoardSize(List board) {
  return sqrt(board.length).toInt();
}

List<int> findCornerPositions(int length) {
  List array = List.generate(length, (index) => index);
  int size = getBoardSize(array);

  int topLeft = array[0];
  int topRight = array[size - 1];
  int bottomLeft = array[size * (size - 1)];
  int bottomRight = array[size * size - 1];

  List<int> corners = [topLeft, topRight, bottomLeft, bottomRight];
  return corners;
}
