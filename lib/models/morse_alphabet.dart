import 'package:morse_trainer/models/audio_players.dart';
import 'package:morse_trainer/models/sound_generator.dart';

// Define the Morse code alphabet and corresponding letter sounds
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

// Create a map to store the Morse code alphabet and their corresponding letter objects
Map<String, Letter> morseAlphabet = {
  // Create Letter objects for each letter in the Morse code alphabet and store them in the map
  for (var k in [for (int i = 0; i < alphabet.length; i++) i])
    alphabet[k]: Letter(name: alphabet[k], sound: morseLetterSounds[k])
};

// Letter class to represent a letter in the Morse code alphabet
class Letter {
  // Properties to store the name (letter) and corresponding Morse code sound
  late final String name;
  late final String sound;

  // Constructor to create a Letter object with a given name and sound
  Letter({required this.name, required this.sound});

  // Method to play the Morse code sound associated with the letter
  Future<void> play() async {
    // Generate the Morse code sound file and play it using the LetterAudioPlayer
    await SoundGenerator.generateSoundFile(sound);
    await LetterAudioPlayer.play();
  }

  // Getter to return the formatted display version of the Morse code sound (trimming space and replacing '.' with '●')
  String get displaySound {
    return sound.replaceAll(" ", "").replaceAll(".", "\u2022");
  }
}
