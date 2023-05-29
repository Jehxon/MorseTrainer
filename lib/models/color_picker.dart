import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';

Future<Color> pickColor(BuildContext context, Color initColor) async {
  Color chosenColor = initColor;
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Choix de la couleur'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: chosenColor,
            onColorChanged: (Color c) {
              chosenColor = c;
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    },
  );
  return chosenColor;
}