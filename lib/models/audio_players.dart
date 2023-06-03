import 'package:audioplayers/audioplayers.dart';

class Audio {
  final AudioPlayer player = AudioPlayer();
  double playBackRate = 1.0;

  Audio(){
    player.setPlayerMode(PlayerMode.lowLatency);
  }

  void setSpeed(double speed) {
    playBackRate = speed;
  }

  void setSource(assetPath) {
    player.setSource(AssetSource(assetPath));
  }

  Future<void> play(String assetPath) async {
    await player.play(AssetSource(assetPath));
    await player.setPlaybackRate(playBackRate);
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