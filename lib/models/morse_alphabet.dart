import 'package:morse_trainer/models/audio_players.dart';
import 'package:morse_trainer/models/sound_generator.dart';

const String alphabet = "abcdefghijklmnopqrstuvwxyz0123456789.,?";
const List<String> morseLetterSounds = [
  ". -", // A
  "- . . .", // B
  "- . - .", // C
  "- . .", // D
  ".", // E
  ". . - .", // F
  "- - .", // G
  ". . . .", // H
  ". .", // I
  ". - - -", // J
  "- . -", // K
  ". - . .", // L
  "- -", // M
  "- .", // N
  "- - -", // O
  ". - - .", // P
  "- - . -", // Q
  ". - .", // R
  ". . .", // S
  "-", // T
  ". . -", // U
  ". . . -", // V
  ". - -", // W
  "- . . -", // X
  "- . - -", // Y
  "- - . .", // Z

  "- - - - -", // 0
  ". - - - -", // 1
  ". . - - -", // 2
  ". . . - -", // 3
  ". . . . -", // 4
  ". . . . .", // 5
  "- . . . .", // 6
  "- - . . .", // 7
  "- - - . .", // 8
  "- - - - .", // 9

  ". - . - . -", // .
  "- - . . - -", // ,
  ". . - - . .", // ?
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
    await SoundGenerator.generateSoundFile(sound);
    await LetterAudioPlayer.play();
  }

  String get displaySound{
    return sound.replaceAll(" ", "").replaceAll(".", "\u2022");
  }
}
