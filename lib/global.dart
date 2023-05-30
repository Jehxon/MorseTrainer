import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:morse_trainer/models/preferences.dart';
import 'package:morse_trainer/models/audio_players.dart';

final Audio audioPlayer = Audio();
final FastAudioPlayer fastAudioPlayer = FastAudioPlayer();

List<Function(Color)> colorChangeCallbacks = [];

Map<String, int> preferences = {
  "appColor": Colors.deepOrange.value,
  "guessLetterNumberOfChoice": 8,
  "guessLetterHighScore": 0,
  "guessLetterShowSound": 1,
  "guessSoundHighScore": 0,
  "guessWordHighScore": 0,
};

List<String> frenchDict = [];

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
  String fileData = await rootBundle.loadString(assetPath);
  List<String> wordList = fileData.trim().split('\n');
  return wordList;
}