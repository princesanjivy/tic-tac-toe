import 'package:tic_tac_toe/model/player.dart';

class RoomData {
  final int code;
  final String roomOwnerId;
  final String turn;
  final DateTime createdAt;
  bool isStarted = false;

  final List<Player> players;
  final List board;

  final int round;

  RoomData(
    this.code,
    this.roomOwnerId,
    this.turn,
    this.players,
    this.board,
    this.round,
    this.createdAt,
  );

  factory RoomData.fromJson(json, int code) {
    List<Player> players = [];
    List.from(json!["players"]).forEach((element) {
      players.add(Player.fromRoomDataJson(element));
    });

    RoomData roomData = RoomData(
      code,
      json!["roomOwnerId"],
      json!["turn"],
      players,
      json!["board"],
      json!["round"],
      DateTime.parse(
        json!["createdAt"],
      ),
    );
    roomData.isStarted = json!["isStarted"];

    return roomData;
  }

  List<Map<String, dynamic>> playersToJson(List<Player> p) {
    List<Map<String, dynamic>> temp = [];
    for (Player element in p) {
      temp.add(element.toJson());
    }

    return temp;
  }

  Map<String, dynamic> toJson() => {
        "roomOwnerId": roomOwnerId,
        "turn": turn,
        "isStarted": isStarted,
        "players": playersToJson(players),
        "board": board,
        "round": round,
        "createdAt": createdAt.toString(),
      };
}
