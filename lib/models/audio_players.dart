import 'package:audioplayers/audioplayers.dart';

class Audio {
  static final AudioPlayer player = AudioPlayer();
  Future<void> play(String assetPath) async {
    if(player.state == PlayerState.playing){
      await player.stop();
    }
    await player.play(AssetSource(assetPath));
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