// lib/core/utils/logger.dart
//
// 結構化日誌封裝（logger 套件）。
// 合規：生產禁用 print；網路層 PII 脫敏由 core/network/log_interceptor 處理。

import 'package:logger/logger.dart';

// 生產環境建議將 level 設為 Level.warning，避免過度輸出。
final appLogger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);
