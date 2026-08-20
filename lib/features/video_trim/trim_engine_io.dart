// lib/features/video_trim/trim_engine_io.dart
//
// 移動端剪輯引擎（Android/iOS）實作。
// 依 video_trimmer 5.0.0（原生 MP4Composer / AVFoundation，無 FFmpeg 依賴）。
// 注意：本檔案只在非 web 平台編譯（由 video_trimmer_engine.dart 條件匯入）。

import 'dart:async';
import 'dart:io';

import 'package:video_trimmer/video_trimmer.dart';

import 'video_trimmer_engine.dart';

/// 移動端剪輯引擎（video_trimmer）。
/// extends 以繼承預設 trimAndBlur（行動端暫緩模糊，回傳未模糊標記）。
class NativeTrimmerEngine extends VideoTrimmerEngine {
  NativeTrimmerEngine({required String filePath}) : _file = File(filePath);

  final File _file;
  final Trimmer _trimmer = Trimmer();

  @override
  int get inputBytes {
    try {
      return _file.lengthSync();
    } catch (_) {
      return 0;
    }
  }

  @override
  Future<Duration> probeDuration() async {
    await _trimmer.loadVideo(videoFile: _file);
    final controller = _trimmer.videoPlayerController;
    return controller?.value.duration ?? Duration.zero;
  }

  @override
  Future<TrimResult> trim(TrimRequest request) async {
    final inputBytes = await _file.length();
    final outputPath = await _saveTrimmed(request);
    final outFile = File(outputPath);
    return TrimResult(
      outputPath: outputPath,
      duration: request.end - request.start,
      inputBytes: inputBytes,
      outputBytes: await outFile.length(),
    );
  }

  Future<String> _saveTrimmed(TrimRequest request) async {
    final completer = Completer<String?>();
    await _trimmer.saveTrimmedVideo(
      startValue: request.start.inMilliseconds.toDouble(),
      endValue: request.end.inMilliseconds.toDouble(),
      onSave: completer.complete,
      videoFolderName: 'media_trim',
      videoFileName:
          'trimmed_${DateTime.now().millisecondsSinceEpoch}',
      storageDir: StorageDir.applicationDocumentsDirectory,
    );
    final path = await completer.future;
    if (path == null) {
      throw Exception('影片剪輯失敗：未取得輸出檔案');
    }
    return path;
  }

  @override
  void dispose() => _trimmer.dispose();
}

/// 平台建立工廠（非 web 分支）。
VideoTrimmerEngine createTrimEngineImpl({
  required Object source,
  required String fileName,
}) {
  return NativeTrimmerEngine(filePath: source as String);
}
