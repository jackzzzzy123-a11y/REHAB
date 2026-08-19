// lib/core/storage/media_file_store_io.dart
//
// 媒體檔案持久化（非 web 分支）：複製到 App 文件目錄 media/<patientId>/。
// 注意：本檔案只在非 web 平台編譯（由 media_file_store.dart 條件匯入）。

import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'media_file_store.dart';

/// 移動端媒體檔案存放。
class MediaFileStoreIo implements MediaFileStore {
  @override
  Future<String?> persist({
    required String patientId,
    required String fileName,
    required String sourcePath,
  }) async {
    final documents = await getApplicationDocumentsDirectory();
    final targetDir = Directory('${documents.path}/media/$patientId');
    await targetDir.create(recursive: true);
    final targetPath = '${targetDir.path}/$fileName';
    await File(sourcePath).copy(targetPath);
    return targetPath;
  }
}

/// 平台建立工廠（非 web 分支）。
MediaFileStore createMediaFileStoreImpl() => MediaFileStoreIo();
