// lib/data/models/media_asset.dart
//
// 辅助影像/影片（模糊处理后）。存前须模糊背景 + 面部特征（P2 实作 media_blur，P1 留接口）。
// 合規：storagePath 指向已模糊、已加密之媒体；绝不存原始可辨识影像。
// 執行 `flutter pub run build_runner build --delete-conflicting-outputs` 生成 .freezed.dart / .g.dart。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_asset.freezed.dart';
part 'media_asset.g.dart';

enum MediaKind { image, video }

@freezed
class MediaAsset with _$MediaAsset {
  const factory MediaAsset({
    required String assetId,
    required String patientId,
    required MediaKind kind,
    required String storagePath, // 已模糊、已加密
    required DateTime capturedAt,
    required bool backgroundBlurred,
    required bool faceBlurred,
  }) = _MediaAsset;

  factory MediaAsset.fromJson(Map<String, dynamic> json) =>
      _$MediaAssetFromJson(json);
}
