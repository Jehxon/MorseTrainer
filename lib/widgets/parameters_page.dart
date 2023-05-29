import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:morse_trainer/global.dart';
import 'package:morse_trainer/models/color_picker.dart';
import 'package:morse_trainer/models/int_picker.dart';
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
                "Nombre de choix disponibles dans le mode 'Reconnaître'"),
            trailing: Text("${preferences["guessLetterNumberOfChoice"]}"),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              preferences["guessLetterShowSound"] == 0
                  ? Ionicons.eye_off
                  : Ionicons.eye,
            ),
            onTap: () async {
              setState(() {
                preferences["guessLetterShowSound"] =
                    1 - preferences["guessLetterShowSound"]!;
                savePreferences();
              });
            },
            title: const Text(
                "Afficher le motif du son dans le mode 'Reconnaître'"),
            trailing: Checkbox(
              value: preferences["guessLetterShowSound"] == 1,
              onChanged: (bool? value) {},
            ),
          ),
        ],
      ),
    );
  }
}
