import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:morse_trainer/models/preferences.dart';
import 'package:morse_trainer/models/audio_players.dart';

// Initialize the GuessAudio player and FastAudioPlayer for audio playback
final GuessAudio audioPlayer = GuessAudio(); // Player used to play correct and incorrect guessing sound
final FastAudioPlayer fastAudioPlayer = FastAudioPlayer(); // Player used for the long press in 'Guess sound' game

// List of callbacks for theme color change
List<Function(Color)> colorChangeCallbacks = [];

// Default preferences for the app
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

// List of words in the dictionary
List<String> wordsDict = [];

// File paths for various audio files
String outputFile = "";
String longDashFile = "";
String dashFile = "";
String dotFile = "";
String silenceFile = "";

// Function to add a callback for theme color change
void addThemeChangeCallback(Function(Color) func) {
  colorChangeCallbacks.add(func);
}

// Function to remove a callback for theme color change
void removeThemeChangeCallback(Function(Color) func) {
  colorChangeCallbacks.remove(func);
}

// Function to change the app's theme color and notify all registered callbacks
void changeAppColor(Color c) {
  preferences["appColor"] = c.value; // Update the app's color preference
  savePreferences(); // Save the updated preferences
  for (int i = 0; i < colorChangeCallbacks.length; i++) {
    colorChangeCallbacks[i](c); // Notify each callback about the color change
  }
}

// Function to format a word by removing diacritics and converting to lowercase
String formatWord(String str) {
  const String withDia = "ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž'";
  const String withoutDia = "AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz ";
  for (int i = 0; i < withDia.length; i++) {
    str = str.replaceAll(withDia[i], withoutDia[i]); // Replace diacritics with their corresponding characters
  }
  str = str.replaceAll(" ", "").toLowerCase().trim(); // Remove spaces, convert to lowercase, and trim
  return str;
}

// Function to load the list of words from an asset file
Future<List<String>> loadWordListFromAsset(String assetPath) async {
  final String fileData = await rootBundle.loadString(assetPath);
  final List<String> wordList = fileData.trim().split('\n'); // Split the file data into individual words
  return wordList;
}

// Function to get the local path for storing files
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// Function to get the file path for a given file name
Future<String> getFilePath(String file) async {
  final String path = await _localPath;
  return "$path/$file"; // Concatenate the local path with the file name to get the full file path
}
