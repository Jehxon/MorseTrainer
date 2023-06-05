import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:morse_trainer/global.dart';
import 'package:morse_trainer/pickers/color_picker.dart';
import 'package:morse_trainer/pickers/int_picker.dart';
import 'package:morse_trainer/pickers/double_picker.dart';
import 'package:morse_trainer/models/preferences.dart';

class ParameterPage extends StatefulWidget {
  const ParameterPage({super.key});

  @override
  State<ParameterPage> createState() => _ParameterPageState();
}

class _ParameterPageState extends State<ParameterPage> {
  @override
  Widget build(BuildContext context) {
    const TextStyle categoryStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    );
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(top: 10, right: 30, left: 30),
        children: [
          const Text(
            "Général",
            style: categoryStyle,
          ),
          const SizedBox(height: 5,),
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
          ListTile(
            leading: const Icon(
              Ionicons.play_forward_circle_sharp,
            ),
            onTap: () async {
              double playBackSpeed = await pickDouble(
                  context, preferences["playBackSpeed"]!/10.toDouble(), 0.5, 3.0, 0.1);
              setState(() {
                preferences["playBackSpeed"] = (playBackSpeed*10).toInt();
                savePreferences();
              });
              letterAudioPlayer.setSpeed(playBackSpeed);
            },
            title: const Text(
                "Vitesse de lecture des lettres"),
            trailing: Text("${preferences["playBackSpeed"]!/10}"),
          ),
          ListTile(
            leading: const Text(
              "0..9",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              setState(() {
                preferences["guessLetterAddNumbersAndSpecialCharacters"] =
                    1 - preferences["guessLetterAddNumbersAndSpecialCharacters"]!;
                savePreferences();
              });
            },
            title: const Text(
                "Inclure les nombres et caractères spéciaux"),
            trailing: Checkbox(
              value: preferences["guessLetterAddNumbersAndSpecialCharacters"] == 1,
              onChanged: (bool? value) {
                setState(() {
                  preferences["guessLetterAddNumbersAndSpecialCharacters"] =
                      1 - preferences["guessLetterAddNumbersAndSpecialCharacters"]!;
                  savePreferences();
                });
              },
            ),
          ),
          const Divider(height: 30.0,),
          const Text(
            "Mode 'Quelle est la lettre ?'",
            style: categoryStyle,
          ),
          const SizedBox(height: 5,),
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
            title: const Text("Nombre de propositions",),
            trailing: Text("${preferences["guessLetterNumberOfChoice"]}"),
          ),
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
                "Afficher le motif du son"),
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
          const Divider(height: 30.0,),
          const Text(
            "Mode 'Quel est le mot ?'",
            style: categoryStyle,
          ),
          const SizedBox(height: 5,),
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
                "Nombre de mots dans le dictionnaire"),
            subtitle: Text("Les mots proposés sont les ${preferences["guessWordNumberOfWords"]} mots les plus fréquents dans la langue française."),
            trailing: Text("${preferences["guessWordNumberOfWords"]}"),
          ),
          ListTile(
            leading: const Icon(
              Ionicons.hourglass_sharp,
            ),
            onTap: () async {
              int betweenLettersTime = await pickInt(
                  context, preferences["betweenLettersTempo"]!, 3, 7, 1);
              setState(() {
                preferences["betweenLettersTempo"] = betweenLettersTime;
                savePreferences();
              });
            },
            title: const Text(
                "Temps entre 2 lettres"),
            subtitle: const Text("Un temps est le temps d'un '\u2022'. Un '-' dure 3 temps. La valeur par défaut est 3."),
            trailing: Text("${preferences["betweenLettersTempo"]}"),
          ),
        ],
      ),
    );
  }
}
