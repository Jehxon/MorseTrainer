import 'package:audioplayers/audioplayers.dart';
import 'package:morse_trainer/global.dart';

// A custom audio player class for playing sound during the GuessWordPage and GuessSoundPage.
class GuessAudio {
  final AudioPlayer player = AudioPlayer();
  bool playing = false;

  // Constructor sets up a listener to detect when the audio playback is completed.
  GuessAudio() {
    player.onPlayerComplete.listen((_) {
      playing = false;
    });
  }

  // Method to play the audio from a given asset path.
  Future<void> play(String assetPath) async {
    // If audio is already playing, stop it before playing the new one.
    if (playing) {
      await player.stop();
    }
    await player.play(AssetSource(assetPath));
    playing = true;
    // Wait until audio playback is completed before continuing.
    while (playing) {
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }
}

// A custom audio player class for playing the generated Morse code sound file in Letter class.
class LetterAudioPlayer {
  static AudioPlayer player = AudioPlayer();

  // Method to play the Morse code sound from the generated sound file.
  static Future<void> play() async {
    // If the player is already playing, stop it before playing the new sound.
    if (player.state == PlayerState.playing) {
      await player.stop();
    }
    await player.play(DeviceFileSource(outputFile));
    // Wait until the player starts playing before continuing.
    while (player.state != PlayerState.playing) {
      await Future.delayed(const Duration(milliseconds: 1));
    }
    // Wait until the player stops playing before continuing.
    while (player.state == PlayerState.playing) {
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }
}

// A custom audio player class for playing the long dash sound in GuessSoundPage.
class FastAudioPlayer {
  static final AudioPlayer player = AudioPlayer();

  // Constructor sets up the player to loop the long dash sound.
  FastAudioPlayer() {
    player.setReleaseMode(ReleaseMode.loop);
    player.setSource(DeviceFileSource(longDashFile));
  }

  // Method to start playing the long dash sound.
  void play() async {
    await player.resume();
  }

  // Method to stop playing the long dash sound and reset the player to the beginning.
  void stop() async {
    await player.pause();
    await player.seek(Duration.zero);
  }
}
