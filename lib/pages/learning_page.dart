import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:morse_trainer/models/morse_alphabet.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.only(top: 10, right: 30, left: 30),
        itemCount: alphabet.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () async {
              await morseAlphabet[alphabet[index]]?.play();
            },
            title: Row(
              children: [
                Text(alphabet[index].toUpperCase()),
                const SizedBox(width: 50),
                Text(
                  morseLetterSounds[index],
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
      ),
    );
  }
}
