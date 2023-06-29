import 'package:tic_tac_toe/model/player.dart';

class RoomData {
  final int code;
  final String roomOwnerId;
  final String turn;

  final List<Player> players;
  final List<Map<int, int>> board;

  RoomData(
    this.code,
    this.roomOwnerId,
    this.turn,
    this.players,
    this.board,
  );

  Map<String, dynamic> toJson() => {
        "roomOwnerId": roomOwnerId,
        "turn": turn,
        "players": players[0].toJson(),
      };
}
