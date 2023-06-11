import 'package:audioplayers/audioplayers.dart';
import 'package:morse_trainer/global.dart';

class GuessAudio {
  final AudioPlayer player = AudioPlayer();
  bool playing = false;

  GuessAudio() {
    player.onPlayerComplete.listen((_) {
      playing = false;
    });
  }

  Future<void> play(String assetPath) async {
    if (playing) {
      await player.stop();
    }
    await player.play(AssetSource(assetPath));
    playing = true;
    while (playing) {
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }
}

class LetterAudioPlayer {
  static AudioPlayer player = AudioPlayer();

  static Future<void> play() async {
    if(player.state == PlayerState.playing){
      await player.stop();
    }
    await player.play(DeviceFileSource(outputFile));
    while (player.state != PlayerState.playing) {
      await Future.delayed(const Duration(milliseconds: 1));
    }
    while (player.state == PlayerState.playing) {
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }
}

class FastAudioPlayer {
  static final AudioPlayer player = AudioPlayer();
  FastAudioPlayer() {
    player.setReleaseMode(ReleaseMode.loop);
    player.setSource(DeviceFileSource(longDashFile));
  }

  void play() async {
    await player.resume();
  }

  void stop() async {
    await player.pause();
    await player.seek(Duration.zero);
  }
}
