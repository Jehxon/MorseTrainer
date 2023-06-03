import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:morse_trainer/global.dart';
import 'package:morse_trainer/models/morse_alphabet.dart';
import 'package:morse_trainer/models/preferences.dart';

Future<void> playWord(String word) async {
  double speedFactor = 10/preferences["playBackSpeed"]!;
  int betweenLettersTempo = (preferences["betweenLettersTempo"]!-1)*100;
  for (int i = 0; i < word.length; i++) {
    morseAlphabet[word[i]]?.play();
    await Future.delayed(morseAlphabet[word[i]]!.duration * speedFactor);
    await Future.delayed(Duration(milliseconds: betweenLettersTempo) * speedFactor);
  }
}

class GuessWordPage extends StatefulWidget {
  const GuessWordPage({super.key});
  @override
  State<GuessWordPage> createState() => _GuessWordPageState();
}

class _GuessWordPageState extends State<GuessWordPage> {
  final int numberWords = preferences["guessWordNumberOfWords"]!;
  final Random randomGenerator = Random();
  late String wordToFind;
  late String wordToFindFormatted;
  String currentGuess = "";
  bool correctGuess = false;
  int streak = 0;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    wordToFind = frenchDict[preferences["guessWordCurrentWord"]!];
    wordToFindFormatted = formatWord(wordToFind);
    streak = preferences["guessWordCurrentScore"]!;
    currentGuess = "";
    correctGuess = false;
    super.initState();
    playWord(wordToFindFormatted);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void drawNewWordToGuess() async {
    setState(() {
      String wordToFindNew = randomWord();
      while (wordToFindNew == wordToFind) {
        wordToFindNew = randomWord();
      }
      wordToFind = wordToFindNew;
      wordToFindFormatted = formatWord(wordToFind);
      currentGuess = "";
      correctGuess = false;
      textEditingController.clear();
    });
    await playWord(wordToFindFormatted);
  }

  String randomWord() {
    int n = min(numberWords, frenchDict.length);
    int choice = randomGenerator.nextInt(n);
    preferences["guessWordCurrentWord"] = choice;
    return frenchDict[choice];
  }

  bool isRightWord(String word) {
    return formatWord(word) == wordToFindFormatted;
  }

  Future<void> onGoodGuess() async {
    setState(() {
      streak += 1;
      correctGuess = true;
    });
    if (streak > preferences["guessWordHighScore"]!) {
      preferences["guessWordHighScore"] = streak;
    }
    await audioPlayer.play("sounds/correct_guess.mp3");
    await Future.delayed(const Duration(seconds: 1));
    drawNewWordToGuess();
  }

  Future<void> onWrongGuess() async {
    setState(() {
      streak = 0;
    });
    await audioPlayer.play("sounds/wrong_guess.mp3");
  }

  Future<void> onGuess() async {
    if (isRightWord(currentGuess)) {
      await onGoodGuess();
    } else {
      await onWrongGuess();
    }
    preferences["guessWordCurrentScore"] = streak;
    savePreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Quel est ce mot ?",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: const ButtonStyle(
                maximumSize: MaterialStatePropertyAll<Size>(Size(140, 100)),
              ),
              onPressed: () async {
                await playWord(wordToFindFormatted);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Écouter"),
                  SizedBox(width: 10),
                  Icon(Ionicons.musical_notes_sharp),
                ],
              ),
            ),
            const Divider(height: 10),
            TextField(
              onChanged: (String s) {
                currentGuess = s;
              },
              onSubmitted: (String s) {
                onGuess();
              },
              onEditingComplete: () {}, // this prevents keyboard from closing
              controller: textEditingController,
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                constraints: const BoxConstraints(
                  maxWidth: 250,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: correctGuess
                        ? Colors.green
                        : Color(preferences["appColor"]!),
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                    maximumSize: MaterialStatePropertyAll<Size>(Size(150, 200)),
                  ),
                  onPressed: () async {
                    if(!correctGuess){
                      currentGuess = "";
                      await onGuess();
                      setState(() {
                        textEditingController.clear();
                        textEditingController.text = wordToFind;
                      });
                      await Future.delayed(const Duration(seconds: 1));
                      drawNewWordToGuess();
                    }
                  },
                  child: const Text("Abandonner"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: const ButtonStyle(
                    maximumSize: MaterialStatePropertyAll<Size>(Size(150, 200)),
                  ),
                  onPressed: () {
                    if(!correctGuess){
                      onGuess();
                    }
                  },
                  child: const Text("Valider"),
                ),
              ],
            ),
            const Divider(height: 20),
            Text(
              "Nombre de réussites d'affilées : $streak\nMeilleur score : ${preferences["guessWordHighScore"]}",
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
