import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:morse_trainer/models/morse_alphabet.dart';

// Widget for displaying the learning page, which shows the Morse alphabet and corresponding sounds
class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.only(top: 10, right: 30, left: 30),
        itemCount: alphabet.length, // Number of characters in the Morse alphabet
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () async {
              await morseAlphabet[alphabet[index]]?.play(); // Play the sound corresponding to the tapped letter
            },
            title: Row(
              children: [
                Text(alphabet[index].toUpperCase()), // Display the letter in uppercase
                const SizedBox(width: 50),
                Text(
                  morseLetterSounds[index].replaceAll(" ", "").replaceAll(".", "\u2022"),
                  // Display the Morse code sound representation with dots (•) and no spaces
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            trailing: const Icon(
              Ionicons.musical_notes_sharp,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        // Divider between each letter in the Morse alphabet
      ),
    );
  }
}
