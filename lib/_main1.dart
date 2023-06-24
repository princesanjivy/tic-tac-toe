import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/room.dart';

import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   runApp(const MyApp());
//   // runApp(
//   //   MultiProvider(
//   //     providers: [
//   //       StreamProvider<DatabaseEvent?>.value(
//   //         value: FirebaseDatabase.instance.ref("/room").onValue,
//   //         initialData: null,
//   //       ),
//   //     ],
//   //     child: const MyApp(),
//   //   ),
//   // );
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF58c4ab),
        ),
      ),
      scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
      home: GameRoom(),
    );
  }
}

class NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
      };
}

// class Home extends StatefulWidget {
//   const Home({super.key});
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   List<int> grid = [];
//   double width = 0;
//   TextEditingController player = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     fillColors();
//     updateWidth();
//   }
//
//   updateWidth() {
//     double i = 0;
//     Timer.periodic(Duration(milliseconds: 250), (timer) {
//       print(i);
//       setState(() {
//         width = i;
//       });
//
//       if (i <= 200) {
//         i += 50;
//       } else {
//         timer.cancel();
//       }
//     });
//   }
//
//   fillColors() {
//     grid.clear();
//     for (int i = 0; i < 9; i++) {
//       grid.add(0);
//     }
//     FirebaseDatabase.instance.ref("/board1").set(grid);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Tic Tac Toe"),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: 200,
//             child: TextField(
//               controller: player,
//             ),
//           ),
//           const SizedBox(
//             height: 12,
//           ),
//           StreamBuilder<DatabaseEvent>(
//               stream: FirebaseDatabase.instance.ref("/board1").onValue,
//               builder: (context, db) {
//                 if (!db.hasData) return const CircularProgressIndicator();
//
//                 return Stack(
//                   children: [
//                     GridView.builder(
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         childAspectRatio: 1,
//                         crossAxisSpacing: 8,
//                         mainAxisSpacing: 8,
//                       ),
//                       shrinkWrap: true,
//                       padding: const EdgeInsets.all(8),
//                       itemCount: grid.length,
//                       itemBuilder: (context, index) {
//                         List<int> pos = [index ~/ 3, index % 3];
//                         List board = db.data!.snapshot.value as List;
//
//                         if (!board.contains(0)) {
//                           fillColors();
//                         }
//
//                         return GestureDetector(
//                           onTap: () {
//                             // DatabaseReference ref = FirebaseDatabase.instance.ref("/board/${pos[0]}");
//                             // ref.once(DatabaseEventType.value).then((data) {
//                             //   List board = data.snapshot.value as List;
//                             //   // 1 = X; 2 = O;
//                             //   board[pos[1]] = 1;
//                             //
//                             //   ref.set(board);
//                             // });
//                             // print(board);
//                             if (board[index] == 0) {
//                               FirebaseDatabase.instance
//                                   .ref("/board1/$index")
//                                   .set(int.parse(player.text));
//                             }
//
//                             // setState(() {
//                             //   // List board = db.data!.snapshot.value as List;
//                             //   if (board[index] == 1) {
//                             //     gridColors[index] = Colors.green;
//                             //   } else if (board[index] == 2) {
//                             //     gridColors[index] = Colors.blue;
//                             //   }
//                             // });
//                           },
//                           child: Container(
//                             color: board[index] == 1
//                                 ? Colors.green
//                                 : board[index] == 2
//                                     ? Colors.blue
//                                     : Colors.white,
//                             child: Center(
//                               child: Text(
//                                 "$pos",
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     Transform.rotate(
//                       angle: 0.785398,
//                       child: Container(
//                         height: 5,
//                         width: 300,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//         ],
//       ),
//     );
//   }
// }
//
//
// room: {
//   "code": 123456,
//   "players": [{"name": "sanjivy", "chose": 1}]
//   "roomOwner": "sanjivy",
//   "turn": 1
// }
