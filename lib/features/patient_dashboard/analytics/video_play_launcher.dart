// lib/features/patient_dashboard/analytics/video_play_launcher.dart
//
// 影片播放入口（P3，條件匯入）。
// - 移動端 → video_play_io.dart：video_player 播放本地檔案
// - Web    → video_play_web.dart：提示已下載到本機（瀏覽器無檔案系統）
// media_tab 僅依賴此檔案，避免 dart:io 污染 web 編譯。

import 'package:flutter/material.dart';

import '../../../data/models/media_asset.dart';
import 'video_play_io.dart'
    if (dart.library.html) 'video_play_web.dart' as launcher;

/// 播放/檢視影片資產。
Future<void> playVideoAsset(BuildContext context, MediaAsset asset) {
  return launcher.playVideoAsset(context, asset);
}
