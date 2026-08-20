// lib/features/video_trim/ffmpeg_time_format.dart
//
// 純函式：將 Duration 轉為 ffmpeg `-ss`/`-to` 時間戳格式 `HH:MM:SS.mmm`。
// 抽離自 Web 剪輯引擎（原 `_format` 位於含 dart:html 的檔案中，無法被非 web
// 單元測試直接引入）。此檔為純 Dart、無平台依賴，可被所有平台與測試匯入。

/// 格式化 [d] 為 ffmpeg 時間戳（`HH:MM:SS.mmm`）。
///
/// 注意：秒/分欄位必須取「分內/時內」餘數，不可直接用 `inSeconds`/`inMinutes`
/// （否則 2 分 3 秒會得到 `00:02:123.400` 這種畸形值，超出兩位寬）。
String formatFFmpegTimestamp(Duration d) {
  String two(int v) => v.toString().padLeft(2, '0');
  final totalSeconds = d.inSeconds;
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = totalSeconds % 60;
  final millis = (d.inMilliseconds % 1000).toString().padLeft(3, '0');
  return '${two(hours)}:${two(minutes)}:${two(seconds)}.$millis';
}
