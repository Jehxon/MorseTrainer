import 'dart:io';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';
import 'package:morse_trainer/global.dart';

class SoundGenerator {
  static double playBackRateFactor = 1.0;
  static int frequencyHz = 800;

  static void setSpeed(double speed) {
    playBackRateFactor = 1/speed;
  }

  static void setFrequency(int freq) {
    frequencyHz = freq;
  }

  static Future<bool> generateTone(
    int frequency,
    double durationSecond,
    String filePath,
  ) async {
    bool result = false;

    File file = File(filePath);
    if (file.existsSync()) {
      file.deleteSync();
    }

    FFmpegSession session = await FFmpegKit.execute('-f lavfi -i "sine=frequency=$frequency:duration=$durationSecond" -filter:a "volume=2.0" $filePath');

    final ReturnCode? returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      result = true;
    }

    return result;
  }

  static Future<bool> regenerateAtomicSounds() async {
    bool res = await generateTone(frequencyHz, 0.1 * playBackRateFactor, dotFile);
    res &= await generateTone(frequencyHz, 0.3 * playBackRateFactor, dashFile);
    res &= await generateTone(frequencyHz, 20, longDashFile);
    res &= await generateTone(0, 0.1 * playBackRateFactor, silenceFile);
    return res;
  }

  static Future<bool> generateSoundFile(String sound) async {
    File file = File(outputFile);
    if (file.existsSync()) {
      file.deleteSync();
    }
    // The FFMPEG command does not work if the sound is only one letter long...
    if(sound == "-"){
      File(dashFile).copySync(outputFile);
      return true;
    }
    if(sound == "."){
      File(dotFile).copySync(outputFile);
      return true;
    }

    String cmd = "-y ";
    for (int i = 0; i < sound.length; i++) {
      cmd += "-i ";
      switch (sound[i]) {
        case ".":
          cmd += "$dotFile ";
          break;
        case "-":
          cmd += "$dashFile ";
          break;
        case " ":
          cmd += "$silenceFile ";
          break;
      }
    }
    cmd += "-filter_complex \"[0:a] [1:a] concat=n=${sound.length}:v=0:a=1 [a]\" -map \"[a]\" $outputFile";

    bool res = false;
    await FFmpegKit.execute(cmd).then((session) async {
      final ReturnCode? returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        res = true;
      }
    });
    return res;
  }
}
