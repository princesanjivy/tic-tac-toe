class Result {
  bool hasWon;
  List<int> positions;

  Result(this.hasWon, this.positions);
}

Result checkWin(List board, int player) {
  int size =
      (board.length / 3).round(); // Calculate the size of the square board

  // Check rows
  for (int i = 0; i < size; i++) {
    int rowStart = i * size;
    List<int> rowPositions = [];
    if (board
        .sublist(rowStart, rowStart + size)
        .every((cell) => cell == player)) {
      for (int j = 0; j < size; j++) {
        rowPositions.add(rowStart + j);
      }
      return Result(true, rowPositions);
    }
  }

  // Check columns
  for (int i = 0; i < size; i++) {
    int colStart = i;
    List<int> colPositions = [];
    if (List.generate(size, (j) => board[colStart + j * size])
        .every((cell) => cell == player)) {
      for (int j = 0; j < size; j++) {
        colPositions.add(colStart + j * size);
      }
      return Result(true, colPositions);
    }
  }

  // Check diagonals
  List<int> diagonalPositions1 = [];
  bool isDiagonal1Win = true;
  for (int i = 0; i < size; i++) {
    int position = i * size + i;
    diagonalPositions1.add(position);
    if (board[position] != player) {
      isDiagonal1Win = false;
      break;
    }
  }

  if (isDiagonal1Win) {
    return Result(true, diagonalPositions1);
  }

  List<int> diagonalPositions2 = [];
  bool isDiagonal2Win = true;
  for (int i = 0; i < size; i++) {
    int position = (i + 1) * size - 1 - i;
    diagonalPositions2.add(position);
    if (board[position] != player) {
      isDiagonal2Win = false;
      break;
    }
  }

  if (isDiagonal2Win) {
    return Result(true, diagonalPositions2);
  }

  // No winning condition found
  return Result(false, []);
}
