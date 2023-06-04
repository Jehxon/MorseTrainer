import 'package:morse_trainer/global.dart';
import 'package:morse_trainer/models/audio_players.dart';

const String alphabet = "abcdefghijklmnopqrstuvwxyz0123456789.,?";
const List<String> morseLetterSounds = [
  "\u2022-", // A
  "-\u2022\u2022\u2022", // B
  "-\u2022-\u2022", // C
  "-\u2022\u2022", // D
  "\u2022", // E
  "\u2022\u2022-\u2022", // F
  "--\u2022", // G
  "\u2022\u2022\u2022\u2022", // H
  "\u2022\u2022", // I
  "\u2022---", // J
  "-\u2022-", // K
  "\u2022-\u2022\u2022", // L
  "--", // M
  "-\u2022", // N
  "---", // O
  "\u2022--\u2022", // P
  "--\u2022-", // Q
  "\u2022-\u2022", // R
  "\u2022\u2022\u2022", // S
  "-", // T
  "\u2022\u2022-", // U
  "\u2022\u2022\u2022-", // V
  "\u2022--", // W
  "-\u2022\u2022-", // X
  "-\u2022--", // Y
  "--\u2022\u2022", // Z

  "-----", // 0
  "\u2022----", // 1
  "\u2022\u2022---", // 2
  "\u2022\u2022\u2022--", // 3
  "\u2022\u2022\u2022\u2022-", // 4
  "\u2022\u2022\u2022\u2022\u2022", // 5
  "-\u2022\u2022\u2022\u2022", // 6
  "--\u2022\u2022\u2022", // 7
  "---\u2022\u2022", // 8
  "----\u2022", // 9

  "\u2022-\u2022-\u2022-", // .
  "--\u2022\u2022--", // ,
  "\u2022\u2022--\u2022\u2022", // ?
];

Map<String, Letter> morseAlphabet = {
  for (var k in [for (int i = 0; i < alphabet.length; i++) i])
    alphabet[k]: Letter(name: alphabet[k], sound: morseLetterSounds[k])
};

class Letter {
  late final String name;
  late final String sound;
  late final String filename;
  late Duration duration;
  final LetterAudioPlayer audioPlayer = LetterAudioPlayer();

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

    switch (name){
      case ".":
        filename = "sounds/period_morse_code.ogg";
        break;
      case ",":
        filename = "sounds/comma_morse_code.ogg";
        break;
      case "?":
        filename = "sounds/question_mark_morse_code.ogg";
        break;
      default:
        filename = "sounds/${name.toUpperCase()}_morse_code.ogg";
    }

    audioPlayer.setSource(filename);
  }

  Future<void> play() async {
    double speedFactor = 10/preferences["playBackSpeed"]!;
    await audioPlayer.setSpeed(1 / speedFactor);
    await audioPlayer.play(filename, duration * speedFactor);
  }
}
