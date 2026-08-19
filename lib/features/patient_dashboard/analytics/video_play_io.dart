// lib/features/patient_dashboard/analytics/video_play_io.dart
//
// 影片播放（非 web 分支）：video_player 播放本地檔案。
// 注意：本檔案只在非 web 平台編譯（由 video_play_launcher.dart 條件匯入）。

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../data/models/media_asset.dart';

/// 以對話框播放影片（移動端本地檔案）。
Future<void> playVideoAsset(BuildContext context, MediaAsset asset) async {
  final controller = VideoPlayerController.file(
    File(asset.storagePath),
  );
  try {
    await controller.initialize();
  } catch (_) {
    unawaited(controller.dispose());
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('無法播放影片（檔案不存在）')),
      );
    }
    return;
  }
  if (!context.mounted) {
    unawaited(controller.dispose());
    return;
  }
  await showDialog<void>(
    context: context,
    builder: (_) => Dialog(
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio == 0
                ? 16 / 9
                : controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  onPressed: () {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('關閉'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  unawaited(controller.dispose());
}
