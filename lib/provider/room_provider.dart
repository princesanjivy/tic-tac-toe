import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/helper/room_code.dart';
import 'package:tic_tac_toe/model/player.dart';
import 'package:tic_tac_toe/model/room.dart';
import 'package:tic_tac_toe/model/symbol.dart';

class RoomProvider with ChangeNotifier {
  String roomPath = "/roomV1/";

  void createRoom(Player player) {
    int code = generateRandomRoomCode();
    List<Map<int, int>> board = [
      {0: 0},
      {1: 0},
    ];

    player.chose = PlaySymbol.x;
    List<Player> players = [];
    players.add(player);

    RoomData roomData = RoomData(
      code,
      player.playerId,
      PlaySymbol.x,
      players,
      board,
    );

    FirebaseDatabase.instance.ref("$roomPath$code").set(roomData.toJson());

    notifyListeners();
  }
}
