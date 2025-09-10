import 'dart:convert';

import 'package:nakama/nakama.dart';

class NakamaService {
  final client = getNakamaClient(
    host: '127.0.0.1',
    ssl: false,
    serverKey: 'defaultkey',
  );
  late final NakamaWebsocketClient socket;
  late final Session session;

  Future<void> init(String deviceId) async {
    // final uuid = Uuid();
    // final deviceId = uuid.v4();
    print("Device Id: $deviceId");
    // session = await client.authenticateDevice(
    //   deviceId: deviceId,
    //   username: username,
    // );
    session = await client.authenticateCustom(id: deviceId, username: deviceId);
    socket = NakamaWebsocketClient.init(
      host: '127.0.0.1',
      ssl: false,
      token: session.token,
    );
    print("init complete");
  }

  Future<Match> createMatch() async {
    return await socket.createMatch();
  }

  Future<Match> joinMatch(String matchId) async {
    return await socket.joinMatch(matchId);
  }

  Stream<MatchPresenceEvent> onMatchPresence() {
    return socket.onMatchPresence;
  }

  Future<void> sendMatchData(
    String matchId,
    int opCode,
    Map<String, dynamic> data,
  ) async {
    print("Send matchData: $data");
    socket.sendMatchData(
      matchId: matchId,
      opCode: opCode,
      data: jsonEncode(data).codeUnits,
    );
  }

  Stream<MatchData> onMatchData() {
    return socket.onMatchData;
  }
}
