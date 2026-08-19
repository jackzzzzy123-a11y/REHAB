// lib/features/video_trim/preview_io.dart
//
// 剪輯預覽控制器（非 web 分支）：video_player 直接播放本地檔案。

import 'dart:io';

import 'package:video_player/video_player.dart';

/// 建立預覽控制器（移動端：本地檔案路徑）。
Future<VideoPlayerController> createPreviewController({
  required Object source,
  required String fileName,
}) async {
  return VideoPlayerController.file(File(source as String));
}
