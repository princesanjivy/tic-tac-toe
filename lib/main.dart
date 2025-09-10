import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/helper/audio_controller.dart';
import 'package:tic_tac_toe/provider/audio_provider.dart';
import 'package:tic_tac_toe/provider/auth_provider.dart';
import 'package:tic_tac_toe/provider/game_provider.dart';
import 'package:tic_tac_toe/provider/room_provider.dart';
import 'package:tic_tac_toe/provider/single_mode_provider.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';
import 'package:tic_tac_toe/provider/tictacit_provider.dart';
import 'package:tic_tac_toe/screen/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.white),
  );

  // create empty object to call init()
  AudioController audioController = AudioController();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TicTacItProvider()),
        ChangeNotifierProvider(create: (context) => GameAuthProvider()),
        ChangeNotifierProvider(create: (context) => RoomProvider()),
        ChangeNotifierProvider(create: (context) => GameProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider.init()),
        ChangeNotifierProvider(create: (context) => AudioProvider.init()),
        ChangeNotifierProvider(create: (context) => SingleModeProvider()),
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
      builder: (context, child) {
        return FixedWidthScaffold(child: child!);
      },
      title: "Tic Tac Toe",
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: "Judson",
        colorScheme: ColorScheme.fromSeed(
          seedColor: Provider.of<ThemeProvider>(
            context,
            listen: true,
          ).primaryColor,
        ),
      ),
      scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
      home: const ScreenController(),
    );
  }
}

class ScreenController extends StatelessWidget {
  const ScreenController({super.key});

  @override
  Widget build(BuildContext context) {
    if (!context.watch<TicTacItProvider>().isAccessChecked) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (context.read<TicTacItProvider>().isValid) {
      return Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return theme.showLoading
              ? const Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Center(
                        //   child: CircularProgressIndicator(),
                        // ),
                        Text(
                          "princeappstudio\npresents",
                          style: TextStyle(color: Colors.cyan, fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : const HomeScreen();
        },
      );
    } else {
      return const Blocked();
    }
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

// Fixed With Scaffold
class FixedWidthScaffold extends StatelessWidget {
  final Widget child;
  static const double targetWidth = 430;

  const FixedWidthScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = constraints.maxWidth / targetWidth;

        return defaultTargetPlatform == TargetPlatform.android
            ? child
            : Container(
                color: Colors.black,
                child: Center(
                  child: Transform.scale(
                    scale: scale.clamp(0.1, 1.0),
                    alignment: Alignment.topCenter,
                    child: SizedBox(width: targetWidth, child: child),
                  ),
                ),
              );
      },
    );
  }
}

class Blocked extends StatelessWidget {
  const Blocked({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text("This page is not available!"))),
    );
  }
}
