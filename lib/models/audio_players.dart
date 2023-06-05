import 'package:audioplayers/audioplayers.dart';

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
  AudioPlayer player = AudioPlayer();
  double playBackRate = 1.0;

  Future<void> setSpeed(double speed) async {
    playBackRate = speed;
    await player.setPlaybackRate(speed);
  }

  Future<void> play(String assetPath) async {
    if(player.state == PlayerState.playing){
      player.stop();
    }
    await player.play(AssetSource(assetPath));
    while (player.state != PlayerState.playing) {
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }
}

class FastAudioPlayer {
  static final AudioPlayer player = AudioPlayer();
  FastAudioPlayer() {
    player.setReleaseMode(ReleaseMode.loop);
    player.setSource(AssetSource("sounds/beep.mp3"));
  }

  void play() async {
    await player.resume();
  }

  void stop() async {
    await player.pause();
    await player.seek(Duration.zero);
  }
}
