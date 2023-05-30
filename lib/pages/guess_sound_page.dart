import 'dart:math';
import 'package:flutter/material.dart';
import 'package:morse_trainer/global.dart';
import 'package:morse_trainer/models/morse_alphabet.dart';
import 'package:morse_trainer/models/preferences.dart';

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
    drawNewSoundToGuess();
    super.initState();
  }

  void drawNewSoundToGuess() {
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
    return alphabet[randomGenerator.nextInt(alphabet.length)];
  }

  bool isRightSound(String sound) {
    return sound == morseAlphabet[letterToFind]!.sound;
  }

  Future<void> onGuess() async {
    if (isRightSound(currentGuess)) {
      setState(() {
        streak += 1;
        correctGuess = true;
      });
      if (streak > preferences["guessSoundHighScore"]!) {
        preferences["guessSoundHighScore"] = streak;
        savePreferences();
      }
      await audioPlayer.play("sounds/correct_guess.mp3");
      await Future.delayed(const Duration(seconds: 1));
      drawNewSoundToGuess();
    } else {
      setState(() {
        streak = 0;
        currentGuess = "";
      });
      await audioPlayer.play("sounds/wrong_guess.mp3");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "Quel son fait cette lettre ?",
              style: TextStyle(
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
                  if(correctGuess){
                    return;
                  }
                  fastAudioPlayer.play();
                  lastPress = DateTime.now();
                },
                onTapUp: (TapUpDetails details) async {
                  if(correctGuess){
                    return;
                  }
                  Duration pressDuration = DateTime.now().difference(lastPress);
                  if(pressDuration < const Duration(milliseconds: 100)){
                    await Future.delayed(const Duration(milliseconds: 100) - pressDuration);
                  }
                  fastAudioPlayer.stop();
                  if (pressDuration > const Duration(milliseconds: 250)) {
                    setState(() {
                      currentGuess = "$currentGuess-";
                    });
                  } else {
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
                  child: const Center(
                    child: Text(
                      "Appuyez !",
                      style: TextStyle(
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
                    setState(() {
                      currentGuess = "";
                    });
                  },
                  child: const Text("Annuler"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: const ButtonStyle(
                    maximumSize: MaterialStatePropertyAll<Size>(Size(150, 200)),
                  ),
                  onPressed: () {
                    onGuess();
                  },
                  child: const Text("Valider"),
                ),
              ],
            ),
            const Divider(height: 20),
            Text(
              "Nombre de réussites d'affilées : $streak\nMeilleur score : ${preferences["guessSoundHighScore"]}",
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
