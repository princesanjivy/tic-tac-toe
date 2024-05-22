import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/helper/audio_controller.dart';
import 'package:tic_tac_toe/provider/audio_provider.dart';
import 'package:tic_tac_toe/provider/single_mode_provider.dart';
import 'package:tic_tac_toe/provider/theme_provider.dart';
import 'package:tic_tac_toe/screen/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.white),
  );

  // create empty object to call init()
  AudioController audioController = AudioController();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider.init(),
        ),
        ChangeNotifierProvider(
          create: (context) => AudioProvider.init(),
        ),
        ChangeNotifierProvider(
          create: (context) => SingleModeProvider(),
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
      title: "Tic Tac Toe",
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: "Judson",
        colorScheme: ColorScheme.fromSeed(
          seedColor:
              Provider.of<ThemeProvider>(context, listen: true).primaryColor,
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
                        style: TextStyle(
                          color: Colors.cyan,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : const HomeScreen();
      },
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
