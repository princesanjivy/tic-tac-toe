import 'package:flutter/material.dart';
import 'package:tic_tac_toe/api/gameit.dart';
import 'package:tic_tac_toe/model/new_player.dart';

class TicTacItProvider extends ChangeNotifier {
  bool _isValid = false;
  bool _checked = false;

  bool get isValid => _isValid;
  bool get isAccessChecked => _checked;

  final Uri uri = Uri.base;

  late Player player;
  late String token;

  int _coins = 0;

  TicTacItProvider() {
    init();
  }

  void init() {
    validateAccess();
  }

  Future<void> validateAccess() async {
    token = uri.queryParameters["token"]!;

    if (token.isEmpty) {
      print("No token provided");
      _isValid = false;
    } else {
      print("Token: $token");
      final bool status = await GameItServiceApi.tokenVerify(token: token);
      if (status) {
        // Get player details
        print("Fetching player details");
        player = await GameItServiceApi.playerGet(token: token);
        print(player.toJson());
        print("Complete");
        _isValid = true;
        // Coins
        // final String raw = uri.queryParameters["coins"]!;
        // if (raw.isNotEmpty) {
        //   _coins = int.parse(raw);
        // }
        _coins = player.coins;
      } else {
        // Reject access and provide reason;
        _isValid = false;
      }
    }

    _checked = true;
    notifyListeners();
  }

  int get coins {
    return _coins;
  }

  set coins(int value) {
    _coins += value;
    notifyListeners();
  }
}
