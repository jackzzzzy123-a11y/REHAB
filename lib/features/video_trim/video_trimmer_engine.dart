// lib/features/video_trim/video_trimmer_engine.dart
//
// 影片剪輯引擎抽象（P3）。
// 平台分派（條件匯入，避免移動端編譯到 web 專用套件）：
// - Android/iOS → NativeTrimmerEngine（video_trimmer 原生 MP4Composer/AVFoundation）
// - Web        → WebTrimmerEngine（ffmpeg_wasm，瀏覽器內裁剪+壓縮）
// 設計沿 RehabDataSource 的依賴倒置風格：上層只依賴此抽象，平台差異封裝在引擎內。

import 'trim_engine_io.dart'
    if (dart.library.html) 'trim_engine_web.dart' as engine_impl;

/// 剪輯請求：起止時間。
class TrimRequest {
  const TrimRequest({required this.start, required this.end});

  final Duration start;
  final Duration end;
}

/// 剪輯結果。
class TrimResult {
  const TrimResult({
    required this.outputPath,
    required this.duration,
    required this.inputBytes,
    required this.outputBytes,
  });

  /// 移動端：裁剪後檔案真實路徑；Web：空（已觸發瀏覽器下載）。
  final String outputPath;

  /// 裁剪後時長（= end - start）。
  final Duration duration;

  /// 原始影片大小（bytes，用於展示減體積效果）。
  final int inputBytes;

  /// 裁剪後大小（bytes）。
  final int outputBytes;
}

/// 剪輯引擎抽象。
abstract class VideoTrimmerEngine {
  /// 原始影片大小（bytes，用於展示減體積效果）。
  int get inputBytes;

  /// 探測影片總時長（並完成載入預備）。
  Future<Duration> probeDuration();

  /// 依 [request] 裁剪並匯出。
  Future<TrimResult> trim(TrimRequest request);

  /// 釋放資源（播放器 / wasm 實例）。
  void dispose();
}

/// 依平台建立剪輯引擎。
///
/// [source]：移動端為字串檔案路徑；Web 端為位元組陣列（file_picker bytes）。
VideoTrimmerEngine createTrimEngine({
  required Object source,
  required String fileName,
}) {
  return engine_impl.createTrimEngineImpl(
    source: source,
    fileName: fileName,
  );
}
