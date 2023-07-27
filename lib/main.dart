import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    super.initState();
    getData();
    addThemeChangeCallback(updateColorCallback);
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
    // wordsDict = await loadWordListFromAsset("assets/data/french_dict_freq.txt");
    SoundGenerator.setSpeed(preferences["playBackSpeed"]!/10);
    SoundGenerator.setFrequency(preferences["frequency"]!);
    outputFile = await getFilePath("current_sound.wav");
    longDashFile = await getFilePath("long_dash.wav");
    dashFile = await getFilePath("dash.wav");
    dotFile = await getFilePath("dot.wav");
    silenceFile = await getFilePath("silence.wav");
    await SoundGenerator.regenerateAtomicSounds();
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
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('fr'), // French
          ],
          theme: theme,
          home: const HomePage(),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
