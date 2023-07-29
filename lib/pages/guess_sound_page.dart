import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:morse_trainer/global.dart';
import 'package:morse_trainer/models/morse_alphabet.dart';
import 'package:morse_trainer/models/preferences.dart';

// Widget for the Guess Sound page, where users can guess Morse code sounds
class GuessSoundPage extends StatefulWidget {
  const GuessSoundPage({super.key});

  @override
  State<GuessSoundPage> createState() => _GuessSoundPageState();
}

class _GuessSoundPageState extends State<GuessSoundPage> {
  final Random randomGenerator = Random();
  int streak = 0;
  String letterToFind = "";
  String currentGuess = "";
  late DateTime lastPress;
  bool correctGuess = false;

  @override
  void initState() {
    // Initialize the state variables when the widget is created
    letterToFind = alphabet[preferences["guessSoundCurrentSound"]!];
    currentGuess = "";
    correctGuess = false;
    streak = preferences["guessSoundCurrentScore"]!;
    // If the setting to include numbers and special characters is disabled and the current sound index is out of the letter range (>=26),
    // draw a new sound to guess
    if (preferences["guessLetterAddNumbersAndSpecialCharacters"] == 0 && preferences["guessSoundCurrentSound"]! >= 26) {
      drawNewSoundToGuess();
    }
    super.initState();
  }

  void drawNewSoundToGuess() {
    // Draw a new sound to guess
    setState(() {
      String letterToFindNew = randomLetter();
      while (letterToFindNew == letterToFind) {
        letterToFindNew = randomLetter();
      }
      letterToFind = letterToFindNew;
      currentGuess = "";
      correctGuess = false;
    });
  }

  String randomLetter() {
    // Get a random letter and update the current sound index
    int maxNumber = preferences["guessLetterAddNumbersAndSpecialCharacters"]! == 0 ? 26 : alphabet.length;
    int n = randomGenerator.nextInt(maxNumber);
    preferences["guessSoundCurrentSound"] = n;
    return alphabet[n];
  }

  bool isRightSound(String sound) {
    // Check if the user's sound guess matches the correct sound
    return sound == morseAlphabet[letterToFind]!.displaySound;
  }

  Future<void> onGoodGuess() async {
    // Handle the case of a correct sound guess and update the streak
    setState(() {
      streak += 1;
      correctGuess = true;
    });
    if (streak > preferences["guessSoundHighScore"]!) {
      preferences["guessSoundHighScore"] = streak;
    }
    await audioPlayer.play("sounds/correct_guess.mp3");
    drawNewSoundToGuess();
  }

  Future<void> onWrongGuess() async {
    // Handle the case of a wrong sound guess and reset the streak and current guess
    setState(() {
      streak = 0;
      currentGuess = "";
    });
    await audioPlayer.play("sounds/wrong_guess.mp3");
  }

  Future<void> onGuess() async {
    // Handle the sound guess logic and update the streak
    if (isRightSound(currentGuess)) {
      await onGoodGuess();
    } else {
      await onWrongGuess();
    }
    preferences["guessSoundCurrentScore"] = streak;
    savePreferences();
  }

  @override
  Widget build(BuildContext context) {
    // Widget build method for rendering the Guess Sound page UI
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text(
              AppLocalizations.of(context)!.guessSoundTitle,
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              letterToFind.toUpperCase(),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 10),
            Text(
              "[ $currentGuess ]",
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Material(
              elevation: 20,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: InkWell(
                onTapDown: (TapDownDetails details) {
                  // Handle the tap-down event when the button is pressed
                  if (correctGuess) {
                    return; // Ignore if the correct sound has already been guessed
                  }
                  fastAudioPlayer.play();
                  lastPress = DateTime.now();
                },
                onTapUp: (TapUpDetails details) async {
                  // Handle the tap-up event when the button is released
                  if (correctGuess) {
                    return; // Ignore if the correct sound has already been guessed
                  }
                  Duration pressDuration = DateTime.now().difference(lastPress);
                  if (pressDuration < const Duration(milliseconds: 100)) {
                    await Future.delayed(const Duration(milliseconds: 100) - pressDuration);
                  }
                  fastAudioPlayer.stop();
                  if (pressDuration > const Duration(milliseconds: 250)) {
                    // If the tap duration was longer than 250 milliseconds, add a dash to the current guess
                    setState(() {
                      currentGuess = "$currentGuess-";
                    });
                  } else {
                    // Otherwise, add a dot to the current guess
                    setState(() {
                      currentGuess = "$currentGuess\u2022";
                    });
                  }
                },
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: correctGuess ? Colors.green : Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                      width: 3,
                      color: correctGuess ? Colors.green : Color(preferences["appColor"]!),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.pressButton,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                    maximumSize: MaterialStatePropertyAll<Size>(Size(150, 200)),
                  ),
                  onPressed: () {
                    // Handle the cancel button press to clear the current guess
                    setState(() {
                      currentGuess = "";
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: const ButtonStyle(
                    maximumSize: MaterialStatePropertyAll<Size>(Size(150, 200)),
                  ),
                  onPressed: () {
                    // Handle the confirm button press to check the sound guess
                    if (!correctGuess) {
                      onGuess();
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.confirm),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                maximumSize: MaterialStatePropertyAll<Size>(Size(150, 200)),
              ),
              onPressed: () async {
                // Handle the give-up button press to reveal the correct sound and draw a new sound to guess
                if (!correctGuess) {
                  currentGuess = "";
                  onGuess();
                  setState(() {
                    currentGuess = morseAlphabet[letterToFind]!.displaySound; // Show the correct sound after giving up
                  });
                  await Future.delayed(const Duration(seconds: 1));
                  drawNewSoundToGuess();
                }
              },
              child: Text(AppLocalizations.of(context)!.giveUp),
            ),
            const Divider(height: 20),
            Text(
              "${AppLocalizations.of(context)!.nbSuccessiveGoodGuesses} : $streak\n${AppLocalizations.of(context)!.highscore} : ${preferences["guessSoundHighScore"]}",
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
