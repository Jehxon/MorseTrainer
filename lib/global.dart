import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:morse_trainer/models/preferences.dart';
import 'package:morse_trainer/models/audio_players.dart';

final GuessAudio audioPlayer = GuessAudio();
final FastAudioPlayer fastAudioPlayer = FastAudioPlayer();

List<Function(Color)> colorChangeCallbacks = [];

Map<String, int> preferences = {
  "appColor": Colors.deepOrange.value,
  "playBackSpeed": 10,
  "frequency": 800,
  "betweenLettersTempo": 3,

  "guessLetterNumberOfChoice": 8,
  "guessLetterCurrentScore": 0,
  "guessLetterHighScore": 0,
  "guessLetterShowSound": 1,
  "guessLetterAddNumbersAndSpecialCharacters": 0,

  "guessSoundHighScore": 0,
  "guessSoundCurrentScore": 0,
  "guessSoundCurrentSound": 0,

  "guessWordNumberOfWords": 20,
  "guessWordHighScore": 0,
  "guessWordCurrentScore": 0,
  "guessWordCurrentWord": 0,
};

List<String> frenchDict = [];
String outputFile = "";
String longDashFile = "";
String dashFile = "";
String dotFile = "";
String silenceFile = "";

void addThemeChangeCallback(Function(Color) func) {
  colorChangeCallbacks.add(func);
}
void removeThemeChangeCallback(Function(Color) func) {
  colorChangeCallbacks.remove(func);
}
void changeAppColor(Color c) {
  preferences["appColor"] = c.value;
  savePreferences();
  for(int i = 0; i < colorChangeCallbacks.length; i++){
    colorChangeCallbacks[i](c);
  }
}

String formatWord(String str) {
  const String withDia = "ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž'";
  const String withoutDia = "AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz ";
  for (int i = 0; i < withDia.length; i++) {
    str = str.replaceAll(withDia[i], withoutDia[i]);
  }
  str = str.replaceAll(" ", "").toLowerCase().trim();
  return str;
}

Future<List<String>> loadWordListFromAsset(String assetPath) async {
  final String fileData = await rootBundle.loadString(assetPath);
  final List<String> wordList = fileData.trim().split('\n');
  return wordList;
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<String> getFilePath(String file) async {
  final String path = await _localPath;
  return "$path/$file";
}