import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:morse_trainer/global.dart';
import 'package:morse_trainer/models/morse_alphabet.dart';
import 'package:morse_trainer/models/preferences.dart';

enum ChoiceState { neutral, correctlyGuessed, wronglyGuessed }

class LetterChoice extends StatelessWidget {
  final String letter;
  final Future<void> Function(int) onPress;
  final int id;
  final ChoiceState state;

  const LetterChoice({
    super.key,
    required this.letter,
    required this.onPress,
    required this.id,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.transparent;
    Color borderColor = Color(preferences["appColor"]!);
    switch (state) {
      case ChoiceState.correctlyGuessed:
        backgroundColor = Colors.green;
        borderColor = Colors.green;
      case ChoiceState.wronglyGuessed:
        backgroundColor = Colors.red;
        borderColor = Colors.red;
      case ChoiceState.neutral:
      // nothing to do
    }
    return Material(
      elevation: 20,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: InkWell(
        onTap: () async {
          if (state == ChoiceState.neutral) {
            await onPress(id);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              width: 3,
              color: borderColor,
            ),
          ),
          child: Center(
            child: Text(
              letter.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GuessLetterPage extends StatefulWidget {
  const GuessLetterPage({super.key});
  @override
  State<GuessLetterPage> createState() => _GuessLetterPageState();
}

class _GuessLetterPageState extends State<GuessLetterPage> {
  int numberOfChoices = preferences["guessLetterNumberOfChoice"]!;
  int showSound = preferences["guessLetterShowSound"]!;
  late String letterToFind;
  late List<LetterChoice> choiceWidgets;
  late List<String> choicesLetters;
  late List<ChoiceState> choicesStates;
  int streak = 0;
  static List<int> numbers = [for (int i = 0; i < alphabet.length; i++) i];

  void updateColorCallback(Color c) {
    setState(() {});
  }

  @override
  void initState() {
    letterToFind = "";
    drawNewLetterToGuess();
    addThemeChangeCallback(updateColorCallback);
    super.initState();
  }

  @override
  void dispose() {
    removeThemeChangeCallback(updateColorCallback);
    super.dispose();
  }

  void drawNewLetterToGuess() {
    setState(() {
      choicesLetters = randomLetters(numberOfChoices);
      if (choicesLetters.first == letterToFind) {
        letterToFind = choicesLetters[1];
      } else {
        letterToFind = choicesLetters.first;
      }
      choicesLetters.shuffle();
      choicesStates = [
        for (int i = 0; i < choicesLetters.length; i++) ChoiceState.neutral
      ];
    });
    morseAlphabet[letterToFind]?.play();
  }

  List<String> randomLetters(int n) {
    numbers.shuffle();
    return [for (int i = 0; i < n; i++) alphabet[numbers[i]]];
  }

  bool isRightChoice(String letter) {
    return letter == letterToFind;
  }

  Future<void> onGuess(int choiceId) async {
    if (isRightChoice(choicesLetters[choiceId])) {
      audioPlayer.play(AssetSource("sounds/correct_guess.mp3"));
      setState(() {
        streak += 1;
        choicesStates[choiceId] = ChoiceState.correctlyGuessed;
      });
      if (streak > preferences["guessLetterHighScore"]!) {
        preferences["guessLetterHighScore"] = streak;
        savePreferences();
      }
      await Future.delayed(const Duration(seconds: 1));
      drawNewLetterToGuess();
    } else {
      audioPlayer.play(AssetSource("sounds/wrong_guess.mp3"));
      setState(() {
        streak = 0;
        choicesStates[choiceId] = ChoiceState.wronglyGuessed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget soundShown = switch (preferences["guessLetterShowSound"]!) {
      0 => const Icon(Ionicons.eye_off),
      _ => Text(
          morseAlphabet[letterToFind]!.sound,
          style: const TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
    };

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "Quelle est cette lettre ?",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            soundShown,
            const SizedBox(height: 10),
            ElevatedButton(
              style: const ButtonStyle(
                maximumSize: MaterialStatePropertyAll<Size>(Size(117, 100)),
              ),
              onPressed: () {
                morseAlphabet[letterToFind]?.play();
              },
              child: const Row(
                children: [
                  Text("Écouter"),
                  SizedBox(width: 10),
                  Icon(Ionicons.musical_notes_sharp),
                ],
              ),
            ),
            const Divider(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                padding: const EdgeInsets.all(30),
                mainAxisSpacing: 30,
                crossAxisSpacing: 30,
                children: [
                  for (int i = 0; i < choicesLetters.length; i++)
                    LetterChoice(
                      letter: choicesLetters[i],
                      onPress: onGuess,
                      id: i,
                      state: choicesStates[i],
                    ),
                ],
              ),
            ),
            const Divider(height: 10),
            Text(
              "Nombre de réussites d'affilées : $streak\nMeilleur score : ${preferences["guessLetterHighScore"]}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
