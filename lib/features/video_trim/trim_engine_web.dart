// lib/features/video_trim/trim_engine_web.dart
//
// Web 端剪輯引擎實作。
// 依 ffmpeg_wasm 1.0.1（瀏覽器內 ffmpeg.wasm，MEMFS 記憶體檔案系統）。
// 裁剪：`-ss <start> -to <end> -c copy`（stream copy 快速裁剪，去掉頭尾）。
// 注意：本檔案只在 web 平台編譯（由 video_trimmer_engine.dart 條件匯入）。
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:ffmpeg_wasm/ffmpeg_wasm.dart';

import 'ffmpeg_time_format.dart';
import 'video_trimmer_engine.dart';

/// Web 端剪輯引擎（ffmpeg.wasm）。
class WebTrimmerEngine implements VideoTrimmerEngine {
  WebTrimmerEngine({required Uint8List bytes, required this.fileName})
      : _bytes = bytes;

  final Uint8List _bytes;
  final String fileName;
  FFmpeg? _ffmpeg;

  static const _inputName = 'input.mp4';
  static const _outputName = 'output.mp4';

  @override
  int get inputBytes => _bytes.length;

  @override
  Future<Duration> probeDuration() async {
    final ff = await _ensureLoaded();
    ff.writeFile(_inputName, _bytes);
    final duration = Completer<Duration>();
    final durationPattern =
        RegExp(r'Duration:\s*(\d+):(\d+):(\d+(?:\.\d+)?)');
    ff.setLogger((log) {
      if (log.type != 'fferr') return;
      final match = durationPattern.firstMatch(log.message);
      if (match == null) return;
      if (duration.isCompleted) return;
      final hours = int.parse(match.group(1)!);
      final minutes = int.parse(match.group(2)!);
      final seconds = double.parse(match.group(3)!);
      duration.complete(
        Duration(
          hours: hours,
          minutes: minutes,
          seconds: seconds.toInt(),
          milliseconds:
              ((seconds - seconds.toInt()) * 1000).round(),
        ),
      );
    });
    // 僅探測時長：不帶輸出參數，ffmpeg 會報「缺少輸出檔」而失敗——屬預期。
    try {
      await ff.run(['-i', _inputName]);
    } catch (_) {
      // 預期失敗，時長已由 logger 回傳。
    }
    return duration.future;
  }

  @override
  Future<TrimResult> trim(TrimRequest request) async {
    final ff = await _ensureLoaded();
    ff.writeFile(_inputName, _bytes);
    await ff.run([
      '-i', _inputName,
      '-ss', formatFFmpegTimestamp(request.start),
      '-to', formatFFmpegTimestamp(request.end),
      '-c', 'copy',
      _outputName,
    ]);
    final output = ff.readFile(_outputName);
    _download(output, fileName);
    // 清理 MEMFS，釋放記憶體。
    ff
      ..unlink(_inputName)
      ..unlink(_outputName);
    return TrimResult(
      outputPath: '',
      duration: request.end - request.start,
      inputBytes: _bytes.length,
      outputBytes: output.length,
    );
  }

  Future<FFmpeg> _ensureLoaded() async {
    var ff = _ffmpeg;
    if (ff != null) return ff;
    ff = createFFmpeg(
      CreateFFmpegParam(
        log: false,
        corePath:
            'https://unpkg.com/@ffmpeg/core@0.11.0/dist/ffmpeg-core.js',
      ),
    );
    await ff.load();
    _ffmpeg = ff;
    return ff;
  }

  void _download(Uint8List bytes, String name) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = name
      ..click();
    html.Url.revokeObjectUrl(url);
    anchor.remove();
  }

  @override
  void dispose() {
    _ffmpeg?.exit();
    _ffmpeg = null;
  }
}

/// 平台建立工廠（web 分支）。
VideoTrimmerEngine createTrimEngineImpl({
  required Object source,
  required String fileName,
}) {
  return WebTrimmerEngine(
    bytes: source as Uint8List,
    fileName: fileName,
  );
}
