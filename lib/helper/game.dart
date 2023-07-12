import 'dart:math';

import 'package:tic_tac_toe/helper/check_win.dart';

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

int findBestMove(List board, int turn) {
  int aiPlayer = turn;
  int opponent = (turn == 1) ? 2 : 1;

  if (isGameOver(board)) {
    return -1; // Return an invalid index indicating the end of the game
  }

  int bestScore = -9999;
  int bestMove = -1;

  for (int i = 0; i < board.length; i++) {
    if (board[i] == 0) {
      board[i] = aiPlayer;
      int score = minimax(board, 0, false, aiPlayer, opponent);
      board[i] = 0;

      if (score > bestScore) {
        bestScore = score;
        bestMove = i;
      }
    }
  }

  return bestMove;
}

int minimax(List board, int depth, bool isMaximizingPlayer, int aiPlayer,
    int opponent) {
  if (isGameOver(board) || depth == 2) {
    return evaluate(board, aiPlayer, opponent);
  }

  if (isMaximizingPlayer) {
    int maxScore = -9999;

    for (int i = 0; i < board.length; i++) {
      if (board[i] == 0) {
        board[i] = aiPlayer;
        int score = minimax(board, depth + 1, false, aiPlayer, opponent);
        board[i] = 0;
        maxScore = max(maxScore, score);
      }
    }

    return maxScore;
  } else {
    int minScore = 9999;

    for (int i = 0; i < board.length; i++) {
      if (board[i] == 0) {
        board[i] = opponent;
        int score = minimax(board, depth + 1, true, aiPlayer, opponent);
        board[i] = 0;
        minScore = min(minScore, score);
      }
    }

    return minScore;
  }
}

int evaluate(List board, int aiPlayer, int opponent) {
  List<List<int>> winningConditions = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
    [0, 4, 8], [2, 4, 6] // Diagonals
  ];

  for (var condition in winningConditions) {
    int cell1 = board[condition[0]];
    int cell2 = board[condition[1]];
    int cell3 = board[condition[2]];

    if (cell1 == cell2 && cell2 == cell3) {
      if (cell1 == aiPlayer) {
        return 2;
      } else if (cell1 == opponent) {
        return -2;
      }
    }
  }

  return 0;
}

bool isGameOver(List board) {
  return (checkWin(board, 1, 3).hasWon ||
      checkWin(board, 2, 3).hasWon ||
      !board.contains(0));
}

// bool checkWin(List board, int player) {
//   List<List<int>> winningConditions = [
//     [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
//     [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
//     [0, 4, 8], [2, 4, 6] // Diagonals
//   ];
//
//   for (var condition in winningConditions) {
//     if (board[condition[0]] == player &&
//         board[condition[1]] == player &&
//         board[condition[2]] == player) {
//       return true;
//     }
//   }
//
//   return false;
// }

// credits: chat.openai.com
// the depth of the minimax algorithm has been increased to 6, allowing the
// AI to look ahead and make better-informed decisions. The evaluate function
// now assigns a score of 10 for a winning move by the AI player and a score
// of -10 for a winning move by the opponent. The findBestMove function then selects
// the move that leads to the highest score for the AI player.
// These adjustments should make the AI more challenging to play against.
// Feel free to modify the depth or further enhance the heuristic
// evaluation function based on your preferences and requirements.
//