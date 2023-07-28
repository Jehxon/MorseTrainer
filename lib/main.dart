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
    getData(); // Initialize app data and preferences
    addThemeChangeCallback(updateColorCallback); // Add callback for theme changes
  }

  void updateColorCallback(Color c){
    // Callback function to update the app's theme color
    setState(() {
      MaterialColor matColor = toMaterialColor(c);
      theme = ThemeData(
          primarySwatch: matColor
      );
    });
  }

  void getData() async {
    // Loads the preferences and generates 'atomic' sounds to play
    await initPreferences(); // Load app preferences
    SoundGenerator.setSpeed(preferences["playBackSpeed"]!/10); // Set sound playback speed
    SoundGenerator.setFrequency(preferences["frequency"]!); // Set sound frequency
    outputFile = await getFilePath("current_sound.wav"); // Get file path for the current sound
    longDashFile = await getFilePath("long_dash.wav"); // Get file path for the long dash sound (used in 'Guess sound' mode to play continuously)
    dashFile = await getFilePath("dash.wav"); // Get file path for the dash sound
    dotFile = await getFilePath("dot.wav"); // Get file path for the dot sound
    silenceFile = await getFilePath("silence.wav"); // Get file path for the silence sound
    await SoundGenerator.regenerateAtomicSounds(); // Regenerate atomic sounds based on preferences
    setState(() {
      initialized = true;
      theme = ThemeData(primarySwatch: toMaterialColor(Color(preferences["appColor"]!))); // Set app theme color based on preferences
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    removeThemeChangeCallback(updateColorCallback); // Remove the theme change callback
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle changes in the app's lifecycle (e.g., when it goes to the background or resumes)
    // Unused for now.
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
      // App is in the background
        break;
      case AppLifecycleState.inactive:
      // App is inactive (might be visible but not active)
        break;
      case AppLifecycleState.resumed:
      // App is in the foreground
        break;
      case AppLifecycleState.detached:
      // App is detached (not responding to events)
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      // If the app data is initialized, show the MaterialApp with the Home Page
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
          Locale('zh'), // Chinese (Simplified)
        ],
        theme: theme, // Set the app's theme
        home: const HomePage(), // Set the Home Page as the starting screen
      );
    } else {
      // If the app data is not initialized yet, show a loading indicator
      return const Center(child: CircularProgressIndicator());
    }
  }
}
