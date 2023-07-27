import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

Future<Color> pickColor(BuildContext context, Color initColor) async {
  Color chosenColor = initColor;
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.pickColor),
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