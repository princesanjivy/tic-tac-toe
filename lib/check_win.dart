bool checkWin(List<int> board, int player) {
  int size = (board.length / 3).round(); // Calculate the size of the square board

  // Check rows
  for (int i = 0; i < size; i++) {
    int rowStart = i * size;
    if (board.sublist(rowStart, rowStart + size).every((cell) => cell == player)) {
      return true;
    }
  }

  // Check columns
  for (int i = 0; i < size; i++) {
    int colStart = i;
    if (List.generate(size, (j) => board[colStart + j * size]).every((cell) => cell == player)) {
      return true;
    }
  }

  // Check diagonals
  if (List.generate(size, (i) => board[i * size + i]).every((cell) => cell == player)) {
    return true;
  }
  if (List.generate(size, (i) => board[(i + 1) * size - 1 - i]).every((cell) => cell == player)) {
    return true;
  }

  // No winning condition found
  return false;
}

