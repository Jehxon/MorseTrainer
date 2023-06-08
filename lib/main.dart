import 'package:flutter/material.dart';
import 'package:morse_trainer/models/preferences.dart';
import 'home_page.dart';
import 'package:morse_trainer/global.dart';
import 'package:morse_trainer/models/sound_generator.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  bool initialized = false;
  ThemeData theme = ThemeData(primarySwatch: Colors.deepOrange);

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getData();
    addThemeChangeCallback(updateColorCallback);
    super.initState();
  }

  void updateColorCallback(Color c){
    setState(() {
      MaterialColor matColor = toMaterialColor(c);
      theme = ThemeData(
          primarySwatch: matColor
      );
    });
  }

  void getData() async {
    await initPreferences();
    frenchDict = await loadWordListFromAsset("assets/data/french_dict_freq.txt");
    letterAudioPlayer.setSpeed(preferences["playBackSpeed"]!/10);
    generateTone(800, 0.3);
    setState(() {
      initialized = true;
      theme = ThemeData(primarySwatch: toMaterialColor(Color(preferences["appColor"]!)));
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    removeThemeChangeCallback(updateColorCallback);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return MaterialApp(
          title: 'Morse Trainer',
          theme: theme,
          home: const HomePage(),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
