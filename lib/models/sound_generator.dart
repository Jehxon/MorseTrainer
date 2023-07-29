import 'dart:io';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';
import 'package:morse_trainer/global.dart';

// SoundGenerator class that provides functions to generate Morse code sounds
class SoundGenerator {
  // Static variables to control playback rate and frequency of generated sounds
  static double playBackRateFactor = 1.0;
  static int frequencyHz = 800;

  // Function to set the playback speed (playback rate) of generated sounds
  static void setSpeed(double speed) {
    playBackRateFactor = 1 / speed;
  }

  // Function to set the frequency of generated sounds
  static void setFrequency(int freq) {
    frequencyHz = freq;
  }

  // Function to generate a tone of a specific frequency and duration and save it to a file
  static Future<bool> generateTone(
      int frequency,
      double durationSecond,
      String filePath,
      ) async {
    bool result = false;

    // Check if the file already exists and delete it to avoid conflicts
    File file = File(filePath);
    if (file.existsSync()) {
      file.deleteSync();
    }

    // Execute FFmpeg command to generate a sine wave of the specified frequency and duration and save it to the file
    FFmpegSession session = await FFmpegKit.execute(
        '-f lavfi -i "sine=frequency=$frequency:duration=$durationSecond" -filter:a "volume=2.0" $filePath');

    final ReturnCode? returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      result = true;
    }

    return result;
  }

  // Function to regenerate atomic Morse code sounds (dot, dash, long dash, and silence)
  static Future<bool> regenerateAtomicSounds() async {
    bool res = await generateTone(frequencyHz, 0.1 * playBackRateFactor, dotFile);
    res &= await generateTone(frequencyHz, 0.3 * playBackRateFactor, dashFile);
    res &= await generateTone(frequencyHz, 20, longDashFile);
    res &= await generateTone(0, 0.1 * playBackRateFactor, silenceFile);
    return res;
  }

  // Function to generate a sound file for a given Morse code sequence
  static Future<bool> generateSoundFile(String sound) async {
    File file = File(outputFile);
    if (file.existsSync()) {
      file.deleteSync();
    }
    // Check if the sound is an atomic sound and if so directly copy the corresponding file
    if (sound == "-") {
      File(dashFile).copySync(outputFile);
      return true;
    }
    if (sound == ".") {
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
    // Execute FFmpeg command to concatenate the atomic sounds and save the resulting sound to the output file
    await FFmpegKit.execute(cmd).then((session) async {
      final ReturnCode? returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        res = true;
      }
    });
    return res;
  }
}
