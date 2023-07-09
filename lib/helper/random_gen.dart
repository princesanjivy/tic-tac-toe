import 'dart:math';

int generateRandomRoomCode() {
  Random random = Random();
  int min = 100000; // Minimum 6-digit number
  int max = 999999; // Maximum 6-digit number
  return min + random.nextInt(max - min);
}

int generateRandomBoardSize() {
  Random random = Random();
  int min = 3;
  int max = 5;

  int number = min + random.nextInt(max - min + 1);
  int size = pow(number, 2) as int;

  return size;
}
