import 'package:audioplayers/audioplayers.dart';

class Audio {
  static final AudioPlayer player = AudioPlayer();
  Audio() {
    player.setPlayerMode(PlayerMode.lowLatency);
  }
  Future<void> play(String assetPath) async {
    await player.play(AssetSource(assetPath));
  }
}

class FastAudioPlayer {
  static final AudioPlayer player = AudioPlayer();
  FastAudioPlayer() {
    player.setSource(AssetSource("sounds/beep.mp3"));
    player.setReleaseMode(ReleaseMode.loop);
  }

  void play() async {
    await player.resume();
  }

  void stop() async {
    await player.pause();
    await player.seek(Duration.zero);
  }
}