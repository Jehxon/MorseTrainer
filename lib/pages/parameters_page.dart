import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ionicons/ionicons.dart';
import 'package:morse_trainer/global.dart';
import 'package:morse_trainer/models/sound_generator.dart';
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
          Text(
            AppLocalizations.of(context)!.generalParameters,
            style: categoryStyle,
          ),
          const SizedBox(height: 5,),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: Text(AppLocalizations.of(context)!.themeParameter),
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
              SoundGenerator.setSpeed(playBackSpeed);
              await SoundGenerator.regenerateAtomicSounds();
            },
            title: Text(AppLocalizations.of(context)!.playBackSpeedParameter),
            trailing: Text("${preferences["playBackSpeed"]!/10}"),
          ),
          ListTile(
            leading: const Icon(
              Icons.graphic_eq,
            ),
            onTap: () async {
              int frequency = await pickInt(
                  context, preferences["frequency"]!, 100, 1000, 25);
              setState(() {
                preferences["frequency"] = frequency;
                savePreferences();
              });
              SoundGenerator.setFrequency(frequency);
              await SoundGenerator.regenerateAtomicSounds();
            },
            title: Text(AppLocalizations.of(context)!.soundFrequencyParameter),
            trailing: Text("${preferences["frequency"]!}"),
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
            title: Text(AppLocalizations.of(context)!.includeNumbersAndSpecialCharactersParameter),
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
          Text("${AppLocalizations.of(context)!.categoryParameter} '${AppLocalizations.of(context)!.guessLetterTitle}'",
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
            title: Text(AppLocalizations.of(context)!.numberOfGuesses),
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
            title: Text(AppLocalizations.of(context)!.showLetterSound),
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
          Text("${AppLocalizations.of(context)!.categoryParameter} '${AppLocalizations.of(context)!.guessWordTitle}'",
            style: categoryStyle,
          ),
          const SizedBox(height: 5,),
          ListTile(
            leading: const Icon(
              Ionicons.list,
            ),
            onTap: () async {
              int n = await pickInt(
                  context, preferences["guessWordNumberOfWords"]!, 10, wordsDict.length, 10);
              setState(() {
                preferences["guessWordNumberOfWords"] = n;
                savePreferences();
              });
            },
            title: Text(AppLocalizations.of(context)!.nbWordsParameter),
            subtitle: Text("${AppLocalizations.of(context)!.nbWordsParameterSubtitle1} ${preferences["guessWordNumberOfWords"]} ${AppLocalizations.of(context)!.nbWordsParameterSubtitle2}"),
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
            title: Text(AppLocalizations.of(context)!.tempoBetweenLetters),
            subtitle: Text(AppLocalizations.of(context)!.tempoBetweenLettersSubtitle),
            trailing: Text("${preferences["betweenLettersTempo"]}"),
          ),
        ],
      ),
    );
  }
}
