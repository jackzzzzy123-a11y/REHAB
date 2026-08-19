// lib/features/video_trim/preview_web.dart
//
// 剪輯預覽控制器（web 分支）：file_picker 回 bytes，
// 以 Blob URL 餵給 video_player（networkUrl）。
// 注意：本檔案只在 web 平台編譯（由 trim_page.dart 條件匯入）。
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:typed_data';

import 'package:video_player/video_player.dart';

/// 建立預覽控制器（web：Blob URL）。
Future<VideoPlayerController> createPreviewController({
  required Object source,
  required String fileName,
}) async {
  final bytes = source as Uint8List;
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  // Blob URL 在頁面卸載時由瀏覽器釋放，無需手動 revoke。
  return VideoPlayerController.networkUrl(Uri.parse(url));
}
