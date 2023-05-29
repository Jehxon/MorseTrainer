import 'package:audioplayers/audioplayers.dart';
import 'package:morse_trainer/global.dart';

const String alphabet = "abcdefghijklmnopqrstuvwxyz";
const List<String> morseLetterSounds = [
  "\u2022-",
  "-\u2022\u2022\u2022",
  "-\u2022-\u2022",
  "-\u2022\u2022",
  "\u2022",
  "\u2022\u2022-\u2022",
  "--\u2022",
  "\u2022\u2022\u2022\u2022",
  "\u2022\u2022",
  "\u2022---",
  "-\u2022-",
  "\u2022-\u2022\u2022",
  "--",
  "-\u2022",
  "---",
  "\u2022--\u2022",
  "--\u2022-",
  "\u2022-\u2022",
  "\u2022\u2022\u2022",
  "-",
  "\u2022\u2022-",
  "\u2022\u2022\u2022-",
  "\u2022--",
  "-\u2022\u2022-",
  "-\u2022--",
  "--\u2022\u2022",
];

Map<String, Letter> morseAlphabet = {
  for (var k in [for (int i = 0; i < alphabet.length; i++) i])
    alphabet[k]: Letter(name: alphabet[k], sound: morseLetterSounds[k])
};

class Letter {
  late final String name;
  late final String sound;

  Letter({required this.name, required this.sound});

  Future<void> play() async {
    await audioPlayer
        .play(AssetSource("sounds/${name.toUpperCase()}_morse_code.ogg"));
  }
}
