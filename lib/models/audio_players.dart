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
  final AudioPlayer player = AudioPlayer();
  double playBackRate = 1.0;
  static bool playing = false;

  LetterAudioPlayer() {
    player.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        playing = true;
      }
    });
  }

  Future<void> setSpeed(double speed) async {
    playBackRate = speed;
    await player.setPlaybackRate(speed);
  }

  void setSource(assetPath) {
    player.setSource(AssetSource(assetPath));
  }

  Future<void> play(String assetPath, Duration d) async {
    if (playing) {
      return;
    }
    DateTime request = DateTime.now();
    await player.play(AssetSource(assetPath));
    while (!playing) {
      await Future.delayed(const Duration(milliseconds: 1));
    }
    DateTime response = DateTime.now();
    await Future.delayed(d - response.difference(request));
    playing = false;
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
