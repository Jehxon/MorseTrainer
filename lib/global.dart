import 'package:flutter/material.dart';
import 'package:morse_trainer/models/preferences.dart';

List<Function(Color)> colorChangeCallbacks = [];

Map<String, int> preferences = {
  "appColor": Colors.deepOrange.value,
  "guessLetterNumberOfChoice": 8,
  "guessLetterHighScore": 0,
  "guessLetterShowSound": 1,
};

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