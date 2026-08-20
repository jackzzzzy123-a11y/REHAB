// test/video_trim_engine_test.dart
//
// P3 剪輯引擎測試：
// 1) formatFFmpegTimestamp 純函式（抽離自 web 引擎，非 web 可單測）。
// 2) NativeTrimmerEngine.inputBytes 安全性（檔案存在回傳大小、不存在回 0 不拋）。
// 3) VideoTrimmerEngine 契約：fake 注入驗證 trim 回傳 duration = end - start
//    且正確傳遞 TrimRequest（依賴倒置：上層只依賴抽象，引擎可替換）。
// 注意：不引入 trim_engine_web.dart（含 dart:html），故僅測移動端引擎 + 純函式。

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_med/features/video_trim/ffmpeg_time_format.dart';
import 'package:rehab_med/features/video_trim/trim_engine_io.dart';
import 'package:rehab_med/features/video_trim/video_trimmer_engine.dart';

void main() {
  group('formatFFmpegTimestamp（純函式）', () {
    test('零值', () {
      expect(formatFFmpegTimestamp(Duration.zero), '00:00:00.000');
    });
    test('僅秒', () {
      expect(formatFFmpegTimestamp(const Duration(seconds: 5)), '00:00:05.000');
    });
    test('分/秒/毫秒', () {
      expect(
        formatFFmpegTimestamp(
          const Duration(minutes: 2, seconds: 3, milliseconds: 400),
        ),
        '00:02:03.400',
      );
    });
    test('接近邊界', () {
      expect(
        formatFFmpegTimestamp(
          const Duration(minutes: 9, seconds: 45, milliseconds: 999),
        ),
        '00:09:45.999',
      );
    });
  });

  group('NativeTrimmerEngine.inputBytes 安全性', () {
    test('存在檔案回傳正確大小', () {
      final f = File(
        '${Directory.systemTemp.path}/trim_in_'
        '${DateTime.now().microsecondsSinceEpoch}.bin',
      )..writeAsBytesSync(List.generate(16, (i) => i));
      final engine = NativeTrimmerEngine(filePath: f.path);
      expect(engine.inputBytes, 16);
      engine.dispose();
      f.deleteSync();
    });

    test('檔案不存在時回傳 0（不拋出）', () {
      final engine = NativeTrimmerEngine(
        filePath: '/no/such/file_'
            '${DateTime.now().microsecondsSinceEpoch}.mp4',
      );
      expect(engine.inputBytes, 0);
      engine.dispose();
    });
  });

  group('VideoTrimmerEngine 契約（fake 注入）', () {
    test('trim 回傳 duration == end - start 且傳遞 request', () async {
      final fake = FakeTrimmerEngine(inputBytes: 100, outputBytes: 40);
      const req = TrimRequest(
        start: Duration(seconds: 10),
        end: Duration(seconds: 30),
      );
      final res = await fake.trim(req);

      // request 正確傳遞給引擎。
      expect(fake.lastRequest, req);
      // duration 等於 end - start（兩個真實引擎皆依此不變式）。
      expect(res.duration, const Duration(seconds: 20));
      expect(res.inputBytes, 100);
      expect(res.outputBytes, 40);
      expect(res.outputPath, 'fake_out');
    });
  });

  group('VideoTrimmerEngine.trimAndBlur 契約', () {
    test('預設實作（不支援模糊）回傳未模糊標記且不變 duration', () async {
      final fake = FakeTrimmerEngine(inputBytes: 100, outputBytes: 40);
      const req = TrimRequest(
        start: Duration(seconds: 10),
        end: Duration(seconds: 30),
      );
      final res = await fake.trimAndBlur(req, blurFace: true);

      expect(res.duration, const Duration(seconds: 20));
      expect(res.faceBlurred, isFalse);
      expect(res.backgroundBlurred, isFalse);
    });

    test('支援模糊的引擎：blurFace 傳遞與標記一致', () async {
      final blur = BlurAwareFake(inputBytes: 100, outputBytes: 40);
      const req = TrimRequest(
        start: Duration(seconds: 10),
        end: Duration(seconds: 30),
      );

      final blurred = await blur.trimAndBlur(req, blurFace: true);
      expect(blur.lastBlurFace, isTrue);
      expect(blurred.faceBlurred, isTrue);
      expect(blurred.backgroundBlurred, isFalse);

      final plain = await blur.trimAndBlur(req, blurFace: false);
      expect(blur.lastBlurFace, isFalse);
      expect(plain.faceBlurred, isFalse);
    });
  });
}

/// 測試用假引擎：記錄 request 並依不變式產生 TrimResult。
/// extends 以繼承預設 trimAndBlur（回傳未模糊標記）。
class FakeTrimmerEngine extends VideoTrimmerEngine {
  FakeTrimmerEngine({this.inputBytes = 0, this.outputBytes = 0});

  @override
  final int inputBytes;
  final int outputBytes;
  TrimRequest? lastRequest;

  @override
  Future<Duration> probeDuration() async => const Duration(seconds: 60);

  @override
  Future<TrimResult> trim(TrimRequest request) async {
    lastRequest = request;
    return TrimResult(
      outputPath: 'fake_out',
      duration: request.end - request.start,
      inputBytes: inputBytes,
      outputBytes: outputBytes,
    );
  }

  @override
  void dispose() {}
}

/// 支援模糊的假引擎：記錄 blurFace 並依其回傳標記。
class BlurAwareFake implements VideoTrimmerEngine {
  BlurAwareFake({this.inputBytes = 0, this.outputBytes = 0});

  @override
  final int inputBytes;
  final int outputBytes;
  bool? lastBlurFace;

  @override
  Future<Duration> probeDuration() async => const Duration(seconds: 60);

  @override
  Future<TrimResult> trim(TrimRequest request) async => TrimResult(
        outputPath: 'fake_out',
        duration: request.end - request.start,
        inputBytes: inputBytes,
        outputBytes: outputBytes,
      );

  @override
  Future<TrimResult> trimAndBlur(
    TrimRequest request, {
    required bool blurFace,
  }) async {
    lastBlurFace = blurFace;
    return TrimResult(
      outputPath: 'fake_out',
      duration: request.end - request.start,
      inputBytes: inputBytes,
      outputBytes: outputBytes,
      faceBlurred: blurFace,
    );
  }

  @override
  void dispose() {}
}
