import 'dart:math';

import 'package:tic_tac_toe/helper/check_win.dart';
import 'package:tic_tac_toe/model/symbol.dart';

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

int findBestMove(List board, int turn, int boardSize) {
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
      int score =
          minimax(board, 0, false, aiPlayer, opponent, -9999, 9999, boardSize);
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
    int opponent, int alpha, int beta, int boardSize) {
  if (isGameOver(board) || depth == 6) {
    return evaluate(board, aiPlayer, opponent, boardSize);
  }

  if (isMaximizingPlayer) {
    int maxScore = -9999;

    for (int i = 0; i < board.length; i++) {
      if (board[i] == 0) {
        board[i] = aiPlayer;
        int score = minimax(board, depth + 1, false, aiPlayer, opponent, alpha,
            beta, boardSize);
        board[i] = 0;
        maxScore = max(maxScore, score);
        alpha = max(alpha, score);
        if (beta <= alpha) {
          break;
        }
      }
    }

    return maxScore;
  } else {
    int minScore = 9999;

    for (int i = 0; i < board.length; i++) {
      if (board[i] == 0) {
        board[i] = opponent;
        int score = minimax(
            board, depth + 1, true, aiPlayer, opponent, alpha, beta, boardSize);
        board[i] = 0;
        minScore = min(minScore, score);
        beta = min(beta, score);
        if (beta <= alpha) {
          break;
        }
      }
    }

    return minScore;
  }
}

int evaluate(List board, int aiPlayer, int opponent, int boardSize) {
  List<List<int>> winningConditions = [];

  // Check rows
  for (int i = 0; i < boardSize; i++) {
    List<int> condition = [];
    for (int j = 0; j < boardSize; j++) {
      condition.add(i * boardSize + j);
    }
    winningConditions.add(condition);
  }

  // Check columns
  for (int i = 0; i < boardSize; i++) {
    List<int> condition = [];
    for (int j = 0; j < boardSize; j++) {
      condition.add(j * boardSize + i);
    }
    winningConditions.add(condition);
  }

  // Check diagonals
  List<int> diagonal1 = [];
  List<int> diagonal2 = [];
  for (int i = 0; i < boardSize; i++) {
    diagonal1.add(i * boardSize + i);
    diagonal2.add(i * boardSize + (boardSize - 1 - i));
  }
  winningConditions.add(diagonal1);
  winningConditions.add(diagonal2);

  for (var condition in winningConditions) {
    int aiCount = 0;
    int opponentCount = 0;

    for (var cell in condition) {
      if (board[cell] == aiPlayer) {
        aiCount++;
      } else if (board[cell] == opponent) {
        opponentCount++;
      }
    }

    if (aiCount == boardSize) {
      return 100; // AI player wins
    } else if (opponentCount == boardSize) {
      return -100; // Opponent wins
    }
  }

  return 0; // Draw or no immediate win/loss
}

// int evaluate(List board, int aiPlayer, int opponent) {
//   // List<List<int>> winningConditions = [
//   //   [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
//   //   [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
//   //   [0, 4, 8], [2, 4, 6] // Diagonals
//   // ];
//
//   List<List<int>> winningConditions = [
//     [0, 1, 2, 3], [4, 5, 6, 7], [8, 9, 10, 11], [12, 13, 14, 15], // Rows
//     [0, 4, 8, 12], [1, 5, 9, 13], [2, 6, 10, 14], [3, 7, 11, 15], // Columns
//     [0, 5, 10, 15], [3, 6, 9, 12] // Diagonals
//   ];
//
//   for (var condition in winningConditions) {
//     int cell1 = board[condition[0]];
//     int cell2 = board[condition[1]];
//     int cell3 = board[condition[2]];
//
//     if (cell1 == cell2 && cell2 == cell3) {
//       if (cell1 == aiPlayer) {
//         return 10;
//       } else if (cell1 == opponent) {
//         return -10;
//       }
//     }
//   }
//
//   return 0;
// }

bool isGameOver(List board) {
  return (checkWin(board, PlaySymbol.xInt, getBoardSize(board)).hasWon ||
      checkWin(board, PlaySymbol.oInt, getBoardSize(board)).hasWon ||
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
