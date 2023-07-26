// ignore_for_file: use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/helper/random_gen.dart';
import 'package:tic_tac_toe/model/player.dart';
import 'package:tic_tac_toe/model/room.dart';
import 'package:tic_tac_toe/model/symbol.dart';

class RoomProvider with ChangeNotifier {
  bool _showLoading = false;
  bool showJoinLoading = false;

  bool get loading {
    return _showLoading;
  }

  set loading(bool v) {
    _showLoading = v;
    notifyListeners();
  }

  Future<int> createRoom(Player player, Widget widget) async {
    loading = true;

    int code = generateRandomRoomCode();
    int round = 1;
    // int code = 123465; // for testing;
    List board = List.generate(generateRandomBoardSize(), (index) => 0);

    player.chose = PlaySymbol.x;
    List<Player> players = [];
    players.add(player);

    RoomData roomData = RoomData(
      code,
      player.playerId,
      PlaySymbol.x,
      players,
      board,
      round,
      DateTime.now(),
    );

    await FirebaseDatabase.instance
        .ref("$roomPath$code")
        .set(roomData.toJson());

    loading = false;

    return code;
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    // });
  }

  Future<void> joinRoom(Player player, int roomCode, Widget widget) async {
    showJoinLoading = true;
    notifyListeners();

    String path = "$roomPath$roomCode/players";

    // DataSnapshot data =
    // await FirebaseDatabase.instance.ref(path).get();

    player.chose = PlaySymbol.o;
    await FirebaseDatabase.instance.ref(path).update({"1": player.toJson()});

    showJoinLoading = false;
    notifyListeners();
  }

  void isStarted(bool v, int roomCode) async {
    await FirebaseDatabase.instance.ref("$roomPath$roomCode/").update(
      {"isStarted": true},
    );
  }

  Future<void> leaveRoom(int roomCode, bool isRoomOwner) async {
    String path = "$roomPath${roomCode}/players/";
    if (isRoomOwner) {
      await FirebaseDatabase.instance.ref("$roomPath${roomCode}").remove();
    } else {
      path += "1";
      await FirebaseDatabase.instance.ref(path).remove();
    }
  }

  Future<bool> isRoomExist(int roomCode) async {
    showJoinLoading = true;
    notifyListeners();

    String path = "$roomPath$roomCode";
    DatabaseEvent databaseEvent =
        await FirebaseDatabase.instance.ref(path).once();

    showJoinLoading = false;
    notifyListeners();

    return databaseEvent.snapshot.value != null;
  }
// updateRoomStatus() {
//
// }
}
