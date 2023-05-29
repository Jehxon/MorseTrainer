import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:morse_trainer/global.dart';

late final SharedPreferences prefs;

Future<void> initPreferences() async {
  prefs = await SharedPreferences.getInstance();
  loadPreferences();
}

void loadPreferences() {
  for (String key in preferences.keys){
    int? value = prefs.getInt(key);
    if(value != null) {
      preferences[key] = value;
    }
  }
}

void savePreferences() async {
  for (String key in preferences.keys){
    await prefs.setInt(key, preferences[key]!);
  }
}

MaterialColor toMaterialColor(Color color) {
  final int red = color.red;
  final int green = color.green;
  final int blue = color.blue;

  final Map<int, Color> shades = {
    50: Color.fromRGBO(red, green, blue, .1),
    100: Color.fromRGBO(red, green, blue, .2),
    200: Color.fromRGBO(red, green, blue, .3),
    300: Color.fromRGBO(red, green, blue, .4),
    400: Color.fromRGBO(red, green, blue, .5),
    500: Color.fromRGBO(red, green, blue, .6),
    600: Color.fromRGBO(red, green, blue, .7),
    700: Color.fromRGBO(red, green, blue, .8),
    800: Color.fromRGBO(red, green, blue, .9),
    900: Color.fromRGBO(red, green, blue, 1),
  };
  return MaterialColor(color.value, shades);
}