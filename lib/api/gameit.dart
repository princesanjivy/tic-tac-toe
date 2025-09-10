import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tic_tac_toe/model/new_player.dart';

class GameItServiceApi {
  static const String baseUrl = "https://gameit-dev-rjq4aqttlq-uc.a.run.app";

  static Future<bool> tokenVerify({required String token}) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"access_token": token}),
      );
      switch (response.statusCode) {
        case HttpStatus.ok:
          final body = jsonDecode(response.body);
          return body["detail"];
        case HttpStatus.unauthorized:
          return false;
        default:
          throw HttpException(
            "Failed to verify token with reason: ${response.statusCode} - ${response.body}",
          );
      }
    } catch (e) {
      throw Exception("Error calling api /verify: $e");
    }
  }

  static Future<Player> playerGet({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/player"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      switch (response.statusCode) {
        case HttpStatus.ok:
          final body = jsonDecode(response.body);
          Player player = Player.fromJson(body["detail"]);
          return player;
        default:
          throw HttpException(
            "Failed to get player with reason: ${response.statusCode} - ${response.body}",
          );
      }
    } catch (e) {
      throw Exception("Error calling api /player: $e");
    }
  }

  static Future<Player> playerByIdGet({
    required String playerId,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/player/$playerId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      switch (response.statusCode) {
        case HttpStatus.ok:
          final body = jsonDecode(response.body);
          Player player = Player.fromJson(body["detail"]);
          return player;
        default:
          throw HttpException(
            "Failed to get player with reason: ${response.statusCode} - ${response.body}",
          );
      }
    } catch (e) {
      throw Exception("Error calling api /player: $e");
    }
  }

  static Future<String> roomCodeForMatchIdGet({
    required String matchId,
    required String token,
  }) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/room/$matchId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      switch (response.statusCode) {
        case HttpStatus.ok:
          final body = jsonDecode(response.body);
          int roomCode = body["room_code"];
          print(roomCode);
          return roomCode.toString();
        default:
          throw HttpException(
            "Failed to get room with reason: ${response.statusCode} - ${response.body}",
          );
      }
    } catch (e) {
      throw Exception("Error calling api /room: $e");
    }
  }

  static Future<String> matchIdFromRoomCodeGet({
    required String roomCode,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/room/$roomCode"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      switch (response.statusCode) {
        case HttpStatus.ok:
          final body = jsonDecode(response.body);
          String matchId = body["match_id"];
          print(matchId);
          return matchId;
        default:
          throw HttpException(
            "Failed to get room with reason: ${response.statusCode} - ${response.body}",
          );
      }
    } catch (e) {
      throw Exception("Error calling api /room: $e");
    }
  }
}
