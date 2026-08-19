// lib/core/storage/media_file_store_web.dart
//
// 媒體檔案持久化（web 分支）：瀏覽器無檔案系統，不落盤。
// 剪輯導出已觸發瀏覽器下載；此處回傳 null，上層以 web_download 標記入庫。
// 注意：本檔案只在 web 平台編譯（由 media_file_store.dart 條件匯入）。

import 'media_file_store.dart';

/// Web 端媒體檔案存放（不落盤，僅標記）。
class MediaFileStoreWeb implements MediaFileStore {
  @override
  Future<String?> persist({
    required String patientId,
    required String fileName,
    required String sourcePath,
  }) async {
    return null;
  }
}

/// 平台建立工廠（web 分支）。
MediaFileStore createMediaFileStoreImpl() => MediaFileStoreWeb();
