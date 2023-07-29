import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ionicons/ionicons.dart';
import 'package:morse_trainer/global.dart';
import 'package:morse_trainer/models/morse_alphabet.dart';
import 'package:morse_trainer/models/preferences.dart';

// Enum representing the different states of a LetterChoice widget
enum ChoiceState { neutral, correctlyGuessed, wronglyGuessed }

// Widget representing a letter choice in the GuessLetterPage
class LetterChoice extends StatelessWidget {
  final String letter; // The letter to display
  final Future<void> Function(int)
      onPress; // Callback function when the letter choice is tapped
  final int id; // Unique identifier for the choice
  final ChoiceState state; // The state of the choice

  const LetterChoice({
    super.key,
    required this.letter,
    required this.onPress,
    required this.id,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the background and border colors based on the state of the choice
    Color backgroundColor = Colors.transparent;
    Color borderColor = Color(preferences["appColor"]!);
    switch (state) {
      case ChoiceState.correctlyGuessed:
        backgroundColor = Colors.green;
        borderColor = Colors.green;
        break;
      case ChoiceState.wronglyGuessed:
        backgroundColor = Colors.red;
        borderColor = Colors.red;
        break;
      case ChoiceState.neutral:
      // nothing to do
    }
    // Return the choice as a Material with InkWell for handling taps
    return Material(
      elevation: 20,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: InkWell(
        onTap: () async {
          // Handle the tap event only when the state is neutral
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
  late List<int> numbers;

  @override
  void initState() {
    // Initialize the state variables when the widget is created
    numbers = [
      for (int i = 0;
          i <
              (preferences["guessLetterAddNumbersAndSpecialCharacters"]! == 0
                  ? 26
                  : alphabet.length);
          i++)
        i
    ];
    letterToFind = "";
    streak = preferences["guessLetterCurrentScore"]!;
    drawNewLetterToGuess();
    super.initState();
  }

  void drawNewLetterToGuess() async {
    // Draw a new letter to guess and update the choices
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
    await morseAlphabet[letterToFind]?.play();
  }

  List<String> randomLetters(int n) {
    // Get a list of random letters for the choices
    numbers.shuffle();
    return [for (int i = 0; i < n; i++) alphabet[numbers[i]]];
  }

  bool isRightChoice(String letter) {
    // Check if the chosen letter is correct
    return letter == letterToFind;
  }

  Future<void> onGuess(int choiceId) async {
    // Handle the letter choice logic and update the streak and choice states
    if (isRightChoice(choicesLetters[choiceId])) {
      setState(() {
        streak += 1;
        for (int i = 0; i < choicesStates.length; i++) {
          choicesStates[i] = ChoiceState.wronglyGuessed;
        }
        choicesStates[choiceId] = ChoiceState.correctlyGuessed;
      });
      if (streak > preferences["guessLetterHighScore"]!) {
        preferences["guessLetterHighScore"] = streak;
      }
      await audioPlayer.play("sounds/correct_guess.mp3");
      drawNewLetterToGuess();
    } else {
      setState(() {
        streak = 0;
        choicesStates[choiceId] = ChoiceState.wronglyGuessed;
      });
      await audioPlayer.play("sounds/wrong_guess.mp3");
    }
    preferences["guessLetterCurrentScore"] = streak;
    savePreferences();
  }

  @override
  Widget build(BuildContext context) {
    // Build the Guess Letter page UI
    Widget soundShown = switch (preferences["guessLetterShowSound"]!) {
      0 => const Icon(Ionicons.eye_off),
      _ => Text(
          morseAlphabet[letterToFind]!.displaySound,
          style: const TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
    };

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)!.guessLetterTitle,
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
          soundShown,
          const SizedBox(height: 10),
          ElevatedButton(
            style: const ButtonStyle(
              maximumSize: MaterialStatePropertyAll<Size>(Size(140, 100)),
            ),
            onPressed: () async {
              // Handle the listen button press to play the letter sound
              await morseAlphabet[letterToFind]?.play();
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
          const Divider(height: 10),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              padding: const EdgeInsets.all(30),
              mainAxisSpacing: 30,
              crossAxisSpacing: 30,
              primary: false,
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
            "${AppLocalizations.of(context)!.nbSuccessiveGoodGuesses} : $streak\n${AppLocalizations.of(context)!.highscore} : ${preferences["guessLetterHighScore"]}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
