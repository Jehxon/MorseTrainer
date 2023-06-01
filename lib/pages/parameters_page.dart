import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:morse_trainer/global.dart';
import 'package:morse_trainer/pickers/color_picker.dart';
import 'package:morse_trainer/pickers/int_picker.dart';
import 'package:morse_trainer/models/preferences.dart';

class ParameterPage extends StatefulWidget {
  const ParameterPage({super.key});

  @override
  State<ParameterPage> createState() => _ParameterPageState();
}

class _ParameterPageState extends State<ParameterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(top: 10, right: 30, left: 30),
        children: [
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Changer le thème'),
            onTap: () async {
              Color pickedColor =
                  await pickColor(context, Color(preferences["appColor"]!));
              setState(() {
                changeAppColor(pickedColor);
              });
            },
            trailing: Icon(
              Icons.circle,
              color: Color(preferences["appColor"]!),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Ionicons.grid,
            ),
            onTap: () async {
              int n = await pickInt(
                  context, preferences["guessLetterNumberOfChoice"]!, 4, 24, 4);
              setState(() {
                preferences["guessLetterNumberOfChoice"] = n;
                savePreferences();
              });
            },
            title: const Text(
                "Nombre de choix disponibles dans le mode 'Quelle est la lettre ?'"),
            trailing: Text("${preferences["guessLetterNumberOfChoice"]}"),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              preferences["guessLetterShowSound"] == 0
                  ? Ionicons.eye_off
                  : Ionicons.eye,
            ),
            onTap: () {
              setState(() {
                preferences["guessLetterShowSound"] =
                    1 - preferences["guessLetterShowSound"]!;
                savePreferences();
              });
            },
            title: const Text(
                "Afficher le motif du son dans le mode 'Quelle est la lettre ?'"),
            trailing: Checkbox(
              value: preferences["guessLetterShowSound"] == 1,
              onChanged: (bool? value) {
                setState(() {
                  preferences["guessLetterShowSound"] =
                      1 - preferences["guessLetterShowSound"]!;
                  savePreferences();
                });
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Ionicons.list,
            ),
            onTap: () async {
              int n = await pickInt(
                  context, preferences["guessWordNumberOfWords"]!, 10, frenchDict.length, 10);
              setState(() {
                preferences["guessWordNumberOfWords"] = n;
                savePreferences();
              });
            },
            title: const Text(
                "Nombre de mots possibles dans le mode 'Quel est le mot ?'"),
            subtitle: const Text("Les mots possibles sont les plus fréquents de la langue française"),
            trailing: Text("${preferences["guessWordNumberOfWords"]}"),
          ),
        ],
      ),
    );
  }
}
