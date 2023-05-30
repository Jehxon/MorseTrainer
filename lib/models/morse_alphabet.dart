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
  late Duration duration;

  Letter({required this.name, required this.sound}) {
    duration = Duration.zero;
    for (int i = 0; i < sound.length; i++) {
      switch (sound[i]) {
        case "\u2022":
          duration += const Duration(milliseconds: 100);
        case "-":
          duration += const Duration(milliseconds: 300);
        default:
      }
    }
    duration += Duration(milliseconds: 100 * sound.length);
  }

  Future<void> play() async {
    await audioPlayer.play("sounds/${name.toUpperCase()}_morse_code.ogg");
  }
}
