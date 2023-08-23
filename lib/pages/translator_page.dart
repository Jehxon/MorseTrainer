import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ionicons/ionicons.dart';
import 'package:morse_trainer/global.dart';
import 'package:morse_trainer/models/audio_players.dart';
import 'package:morse_trainer/models/morse_alphabet.dart';
import 'package:morse_trainer/models/sound_generator.dart';

// Widget for the Guess Word page, where users can guess Morse code words
class TranslatorPage extends StatefulWidget {
  const TranslatorPage({super.key});

  @override
  State<TranslatorPage> createState() => _TranslatorPageState();
}

class _TranslatorPageState extends State<TranslatorPage> {
  final TextEditingController morseTextEditingController = TextEditingController();
  final TextEditingController englishTextEditingController = TextEditingController();
  String englishInput = "";
  String morseInput = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    morseTextEditingController.dispose();
    englishTextEditingController.dispose();
    super.dispose();
  }

  String translateToMorse(String english){
    List<String> words = english.split(" ");
    String writtenMorse = "";
    for (int w = 0; w < words.length; w++) {
      String word = formatWord(words[w]);
      for (int i = 0; i < word.length; i++) {
        String char = word[i];
        if(!morseAlphabet.containsKey(char)){
          continue;
        }
        writtenMorse = "$writtenMorse ${morseAlphabet[char]!.displaySound}";
      }
      writtenMorse = "$writtenMorse / ";
    }
    return writtenMorse.replaceRange(writtenMorse.length-3, writtenMorse.length, "").trim(); // Remove last ' / '
  }

  String translateToEnglish(String morse){
    String res = "";
    String cleanMorseText = cleanMorseInput(morse);
    List<String> words = cleanMorseText.split("w");
    for (int w = 0; w < words.length; w++) {
      String word = words[w];
      List<String> letters = word.split("l");
      for (int l = 0; l < letters.length; l++) {
        String letter = letters[l];
        int letterIndex = morseLetterSounds.indexWhere((element) => element.replaceAll(" ", "") == letter);
        if(letterIndex != -1){
          res += alphabet[letterIndex];
        }
      }
      res += " ";
    }
    return res.trim();
  }

  String cleanMorseInput(String input){
    String cleanMorseText = input.
      replaceAll(RegExp(r" */ *"), "w"). // End word (any number of spaces then '/' then any number of spaces again will match
      replaceAll(RegExp(r" +"), "l"). // End letters (one or more spaces)
      replaceAll("\u2022", "."). // dots are '.'
      replaceAll("_", "-"); // dashes are '-'
    return cleanMorseText;
  }

  String writtenMorseToSound(String morseText){
    String cleanMorseText = cleanMorseInput(morseText);

    String morseSound = "";
    for (int i = 0; i < cleanMorseText.length; i++) {
      String char = cleanMorseText[i];
      switch(char) {
        case ".":
          morseSound += ". ";
          break;
        case "-":
          morseSound += "- ";
          break;
        case "l":
          morseSound += " "*2; // Between letters
          break;
        case "w":
          morseSound += " "*6; // Between words
          break;
      }
    }
    return morseSound;
  }

  Future<void> playText() async {
    await SoundGenerator.generateSoundFile(writtenMorseToSound(morseTextEditingController.text));
    await LetterAudioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    // Widget build method for rendering the Guess Word page UI
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.translatorTitle,
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (String s) {
                englishInput = s;
                morseTextEditingController.text = translateToMorse(englishInput);
              },
              controller: englishTextEditingController,
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
              ),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.englishVersion,
                border: const OutlineInputBorder(),
                constraints: const BoxConstraints(
                  maxWidth: 300,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(preferences["appColor"]!),
                    width: 2.0,
                  ),
                ),
              ),
              maxLines: 2,
            ),
            const Divider(height: 10),
            TextField(
              onChanged: (String s) {
                morseInput = s;
                englishTextEditingController.text = translateToEnglish(morseInput);
              },
              controller: morseTextEditingController,
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 23,
              ),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.morseVersion,
                border: const OutlineInputBorder(),
                constraints: const BoxConstraints(
                  maxWidth: 300,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(preferences["appColor"]!),
                    width: 2.0,
                  ),
                ),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: const ButtonStyle(
                maximumSize: MaterialStatePropertyAll<Size>(Size(140, 100)),
              ),
              onPressed: () async {
                await playText();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.listenButton),
                  const SizedBox(width: 10),
                  const Icon(Ionicons.musical_notes_sharp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
