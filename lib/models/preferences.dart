import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:morse_trainer/global.dart';

// SharedPreferences instance to manage app preferences
late final SharedPreferences prefs;

// Function to initialize SharedPreferences and load preferences from storage
Future<void> initPreferences() async {
  // Get the SharedPreferences instance
  prefs = await SharedPreferences.getInstance();
  // Load preferences from storage
  loadPreferences();
}

// Function to load preferences from SharedPreferences and update the global preferences map
void loadPreferences() {
  for (String key in preferences.keys) {
    // Get the value of each preference key from SharedPreferences
    int? value = prefs.getInt(key);
    if (value != null) {
      // Update the global preferences map if the value exists in SharedPreferences
      preferences[key] = value;
    }
  }
}

// Function to save the updated global preferences map back to SharedPreferences
void savePreferences() async {
  for (String key in preferences.keys) {
    // Save each key-value pair in the global preferences map to SharedPreferences
    await prefs.setInt(key, preferences[key]!);
  }
}

// Function to convert a Color to MaterialColor for consistent color theme usage
MaterialColor toMaterialColor(Color color) {
  final int red = color.red;
  final int green = color.green;
  final int blue = color.blue;

  // Map shades of the color for various intensity levels
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
  // Create and return a MaterialColor using the provided color value and shades
  return MaterialColor(color.value, shades);
}
