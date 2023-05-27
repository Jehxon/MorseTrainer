import 'package:audioplayers/audioplayers.dart';

const String alphabet = "abcdefghijklmnopqrstuvwxyz";
const List<String> morseLetterSounds = [
  ".-",
  "-...",
  "-.-.",
  "-..",
  ".",
  "..-.",
  "--.",
  "....",
  "..",
  ".---",
  "-.-",
  ".-..",
  "--",
  "-.",
  "---",
  ".--.",
  "--.-",
  ".-.",
  "...",
  "-",
  "..-",
  "...-",
  ".--",
  "-..-",
  "-.--",
  "--..",
];

Map<String, Letter> morseAlphabet = {
  for (var k in [for (int i = 0; i < alphabet.length; i++) i])
    alphabet[k]: Letter(name: alphabet[k], sound: morseLetterSounds[k])
};

class Letter {
  late final String name;
  late final String sound;
  final player = AudioPlayer();

  Letter({required this.name, required this.sound});

  Future<void> play() async {
    await player
        .play(AssetSource("sounds/${name.toUpperCase()}_morse_code.ogg"));
  }
}
