import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/board.dart';
import 'package:tic_tac_toe/check_win.dart';

class GameRoom extends StatefulWidget {
  const GameRoom({super.key});

  @override
  State<GameRoom> createState() => _GameRoomState();
}

class _GameRoomState extends State<GameRoom> {
  TextEditingController playerName = TextEditingController();
  TextEditingController roomCode = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// test chechWin
    List<int> board = [0, 1, 2, 2, 1, 1, 2, 1, 0];
    print(checkWin(board, 1, 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                controller: playerName,
                decoration: InputDecoration(
                  label: Text("Player name"),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: roomCode,
                decoration: InputDecoration(
                  label: Text("Room code"),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () async {
                String name = playerName.text.trim();
                FirebaseDatabase.instance.ref("/room").set(
                  {
                    "code": 123456,
                    "roomOwner": name,
                    "turn": 1,
                    "players": [
                      {"name": name, "chose": 1},
                    ],
                  },
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Board(
                            turn: 1,
                          )),
                );
              },
              child: Text("Create room"),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () async {
                String name = playerName.text.trim();
                DataSnapshot data =
                    await FirebaseDatabase.instance.ref("/room").get();

                print(data.value);
                Map roomData = data.value as Map;

                if (roomData["code"] == int.parse(roomCode.text.trim())) {
                  List temp = roomData["players"];
                  temp.add({"chose": 2, "name": name});
                  roomData["players"] = temp;

                  FirebaseDatabase.instance.ref("/room").set(roomData);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Board(
                              turn: 2,
                            )),
                  );
                }
              },
              child: Text("Join room"),
            ),
          ],
        ),
      ),
    );
  }
}
