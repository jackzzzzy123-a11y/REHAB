// lib/features/patient_dashboard/analytics/video_play_web.dart
//
// 影片播放（web 分支）：瀏覽器無檔案系統，剪輯導出已下載到本機。
// 此處僅提示下載位置，不嘗試播放。
// 注意：本檔案只在 web 平台編譯（由 video_play_launcher.dart 條件匯入）。

import 'package:flutter/material.dart';

import '../../../data/models/media_asset.dart';

/// 提示影片已下載到本機（web）。
Future<void> playVideoAsset(
  BuildContext context,
  MediaAsset asset,
) async {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('影片已下載到本機，請在瀏覽器下載區查看')),
  );
}
