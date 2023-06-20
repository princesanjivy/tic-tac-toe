import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Board extends StatefulWidget {
  const Board({super.key, required this.turn});

  final int turn;

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<int> grid = [];

  @override
  void initState() {
    super.initState();

    if (widget.turn == 1) {
      emptyBoard();
    }
  }

  emptyBoard() {
    grid.clear();
    for (int i = 0; i < 9; i++) {
      grid.add(0);
    }
    FirebaseDatabase.instance.ref("/room/board").set(grid);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Player ${widget.turn}"),
      ),
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: 400,
          ),
          child: StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance.ref("/room").onValue,
              builder: (context, db) {
                if (!db.hasData) return const CircularProgressIndicator();
                return GridView.builder(
                  padding: EdgeInsets.all(8),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    // childAspectRatio: 1,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    Map roomData = db.data!.snapshot.value as Map;
                    List board = roomData["board"] as List;

                    /// needs to be changed
                    // if (!board.contains(0)) {
                    //   emptyBoard();
                    // }

                    return GestureDetector(
                      onTap: () {
                        if (board[index] == 0 &&
                            roomData["turn"] == widget.turn) {
                          /// not efficient way of doing
                          FirebaseDatabase.instance
                              .ref("/room/board/$index")
                              .set(widget.turn);
                          FirebaseDatabase.instance
                              .ref("/room/turn")
                              .set(widget.turn == 1 ? 2 : 1);
                        }
                      },
                      child: Material(
                        clipBehavior: Clip.antiAlias,
                        elevation: 8,
                        shape: BeveledRectangleBorder(
                          side: BorderSide(
                            color: Colors.blue,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          color: Colors.blue.shade100,
                          child: Center(
                            child: Text(
                              board[index] == 1
                                  ? "x"
                                  : board[index] == 2
                                      ? "o"
                                      : "",
                              style: GoogleFonts.orbitron(
                                color: board[index] == 1
                                    ? Colors.indigo
                                    : board[index] == 2
                                        ? Colors.pink
                                        : Colors.white,
                                fontSize: 60,
                                // fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          emptyBoard();
        },
        child: Icon(Icons.restart_alt_rounded),
      ),
    );
  }
}
