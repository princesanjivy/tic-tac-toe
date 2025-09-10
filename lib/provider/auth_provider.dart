import 'package:flutter/material.dart';
import 'package:tic_tac_toe/model/player.dart';

class GameAuthProvider with ChangeNotifier {
  final bool loading = false;

  final String displayPicture = "";
  final String name = "";

  final Player player = Player(
    "princesanjivy",
    "1",
    "https://images.unsplash.com/photo-1573865526739-10659fec78a5?q=80&w=1315&auto=format&fit=crop",
  );

  Future<Player> getUserById() async {
    return player;
  }
}
