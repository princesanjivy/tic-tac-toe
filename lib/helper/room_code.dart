import 'dart:math';

int generateRandomRoomCode() {
  Random random = Random();
  int min = 100000; // Minimum 6-digit number
  int max = 999999; // Maximum 6-digit number
  return min + random.nextInt(max - min);
}
