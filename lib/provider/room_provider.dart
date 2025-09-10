// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nakama/nakama.dart';
import 'package:tic_tac_toe/api/gameit.dart';
import 'package:tic_tac_toe/model/new_player.dart';
import 'package:tic_tac_toe/model/room.dart';

import '../nakama_service.dart';

// const int OP_MOVE = 1;
// const int OP_START = 2;
// const int OP_INIT = 0;

class RoomProvider with ChangeNotifier {
  final NakamaService nakamaService = NakamaService();
  Match? currentMatch;
  List<UserPresence> userPresencePlayers = [];
  bool isConnecting = false;

  bool _showLoading = false;
  bool showJoinLoading = false;
  bool isRoomOwner = false;

  var roomPath = ""; // TODO: change it

  bool get loading {
    return _showLoading;
  }

  set loading(bool v) {
    _showLoading = v;
    notifyListeners();
  }

  late RoomData roomData;

  Future<String> createRoom(String token) async {
    loading = true;
    isRoomOwner = true;
    notifyListeners();

    // int code = generateRandomRoomCode();
    // roomData = RoomData(
    //   code,
    //   player.playerId,
    //   PlaySymbol.x,
    //   players,
    //   board,
    //   round,
    //   DateTime.now(),
    // );

    final Match match = await nakamaService.createMatch();
    currentMatch = match;
    userPresencePlayers = List.from(match.presences);
    _listenPresence();
    _listenData();

    final String roomCode = await GameItServiceApi.roomCodeForMatchIdGet(
      matchId: match.matchId,
      token: token,
    );
    await Future.delayed(const Duration(seconds: 2));
    loading = false;
    notifyListeners();

    return roomCode;
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    // });
  }

  Future<void> joinRoom(String roomCode, String token) async {
    showJoinLoading = true;
    notifyListeners();

    // player.chose = PlaySymbol.o;
    // await FirebaseDatabase.instance.ref(path).update({"1": player.toJson()});

    final String matchId = await GameItServiceApi.matchIdFromRoomCodeGet(
      roomCode: roomCode,
      token: token,
    );
    print(matchId);
    final Match match = await nakamaService.joinMatch(matchId);
    currentMatch = match;
    userPresencePlayers = List.from(match.presences);
    _listenPresence();
    _listenData();

    // await nakamaService.sendMatchData(
    //   match.matchId,
    //   0, // init
    //   {"message": "ok", "room": roomCode},
    // );
    showJoinLoading = false;
    notifyListeners();
  }

  void isStarted(bool v, int roomCode) async {
    await FirebaseDatabase.instance.ref("$roomPath$roomCode/").update({
      "isStarted": true,
    });
  }

  Future<void> leaveRoom(int roomCode, bool isRoomOwner) async {
    String path = "$roomPath$roomCode/players/";
    if (isRoomOwner) {
      await FirebaseDatabase.instance.ref("$roomPath$roomCode").remove();
    } else {
      path += "1";
      await FirebaseDatabase.instance.ref(path).remove();
    }
  }

  Future<bool> isRoomExist(int roomCode) async {
    showJoinLoading = true;
    notifyListeners();

    String path = "$roomPath$roomCode";
    DatabaseEvent databaseEvent = await FirebaseDatabase.instance
        .ref(path)
        .once();

    showJoinLoading = false;
    notifyListeners();

    return databaseEvent.snapshot.value != null;
  }

  Future<Player> getPlayer(String playerId, String token) async {
    return await GameItServiceApi.playerByIdGet(
      playerId: playerId,
      token: token,
    );
  }

  // New logics

  Future<void> connect(String id) async {
    isConnecting = true;
    notifyListeners();

    await nakamaService.init(id);

    isConnecting = false;
    notifyListeners();
  }

  // Future<void> create() async {
  //   final match = await nakamaService.createMatch();
  //   currentMatch = match;
  //   players = List.from(match.presences);
  //   _listenPresence();
  //   _listenData();
  //   notifyListeners();
  // }

  void _listenPresence() {
    nakamaService.onMatchPresence().listen((event) {
      print("Event: $event");
      userPresencePlayers.addAll(event.joins);
      userPresencePlayers.removeWhere((p) => event.leaves.contains(p));

      print(userPresencePlayers.first.userId);
      print(userPresencePlayers.first.username);

      print("Total players: ${userPresencePlayers.length}");
      notifyListeners();
    });
  }

  bool isRoomDataRec = false;

  void _listenData() {
    nakamaService.onMatchData().listen((data) async {
      String jsonString = String.fromCharCodes(data.data as Iterable<int>);
      final decoded = jsonDecode(jsonString);
      print("Decoded data: $decoded");
      if (data.opCode == 2) {
        // gameStarted = true;
      } else if (data.opCode == 0) {
        print("init");
        isRoomDataRec = true;
        await nakamaService.sendMatchData(
          currentMatch!.matchId,
          45, // init
          {"message": "ok", "room": roomData.toJson()},
        );
      } else if (data.opCode == 45) {
        roomData = RoomData.fromJson(decoded["room"], 2242);
        isRoomDataRec = true;
        print(true);
      }
      notifyListeners();
    });
  }
}
