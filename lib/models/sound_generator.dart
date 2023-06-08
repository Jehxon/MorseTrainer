import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';

void generateTone(int frequencyHz, double durationSecond){
  FFmpegKit.execute('-f lavfi -i "sine=frequency=$frequencyHz:duration=$durationSecond" test.ogg').then((session) async {
  final ReturnCode? returnCode = await session.getReturnCode();

  if (ReturnCode.isSuccess(returnCode)) {
    // SUCCESS
    print("Sucess !");
  } else if (ReturnCode.isCancel(returnCode)) {
    // CANCEL
    print("Cancel ??");
  } else {
    // ERROR
    print("Error...");
  }
  });
}

