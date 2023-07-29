import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Function to display a color picker dialog and return the chosen color
Future<Color> pickColor(BuildContext context, Color initColor) async {
  Color chosenColor = initColor; // Initialize the chosen color to the initial color

  // Show the dialog with the FlutterColorPicker widget inside
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.pickColor), // Display localized "Pick Color" text as the dialog title
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: chosenColor, // Set the current color of the color picker
            onColorChanged: (Color c) {
              chosenColor = c; // Update the chosen color when a new color is selected
              Navigator.of(context).pop(); // Close the dialog after the color is chosen
            },
          ),
        ),
      );
    },
  );
  return chosenColor; // Return the chosen color after the dialog is closed
}
