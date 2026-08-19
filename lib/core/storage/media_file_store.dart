// lib/core/storage/media_file_store.dart
//
// 媒體檔案持久化抽象（P3）。
// 平台差異（條件匯入）：
// - 移動端 → MediaFileStoreIo：複製到 App 文件目錄 media/<patientId>/
// - Web    → MediaFileStoreWeb：瀏覽器無檔案系統，回傳 null（上層以 web_download 標記）

import 'media_file_store_io.dart'
    if (dart.library.html) 'media_file_store_web.dart' as store_impl;

/// 媒體檔案存放服務。
// ignore: one_member_abstracts
abstract class MediaFileStore {
  /// 將 [sourcePath] 指向的檔案持久化到媒體目錄，回傳 storagePath。
  ///
  /// Web 端不支援（無檔案系統），回傳 null——上層改用下載標記記錄。
  Future<String?> persist({
    required String patientId,
    required String fileName,
    required String sourcePath,
  });
}

/// 建立媒體檔案存放服務（依平台分派）。
MediaFileStore createMediaFileStore() => store_impl.createMediaFileStoreImpl();
