import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/firebase_options.dart';
import 'package:tic_tac_toe/helper/audio_controller.dart';
import 'package:tic_tac_toe/provider/game_provider.dart';
import 'package:tic_tac_toe/provider/login_provider.dart';
import 'package:tic_tac_toe/provider/room_provider.dart';
import 'package:tic_tac_toe/screen/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.white),
  );

  AudioController.playAudio =
      false; // TODO: remove this once shared prefs is in place

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RoomProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GameProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

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
        useMaterial3: false,
        textTheme: GoogleFonts.judsonTextTheme().copyWith(
            // bodyMedium: GoogleFonts.judson(
            //   color: secondaryColor,
            //   fontSize: defaultTextSize,
            // ),
            ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
        ),
      ),
      scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
      home: HomeScreen(),
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
