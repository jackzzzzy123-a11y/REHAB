// lib/core/notification/notification_service.dart
//
// 通知服務（P1 本機通知骨架，P1-5 擴充遠端推送）。
// - showLocal：匯入完成 / 刪除 / 更新等本機事件提醒（Q19 A）。
// - registerPush：phase 2 接後端推送時實作（預留介面）。
// 合規：通知僅含非敏感摘要（匯入筆數、患者代稱），不含原始資料。

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/logger.dart';

class NotificationService {
  NotificationService(this._plugin);
  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    if (kIsWeb) {
      // Web 端 flutter_local_notifications 不支援 → 降級為 no-op。
      // （決策與備援方案見 docs/cross_platform_matrix.md §通知。）
      appLogger.w('本機通知於 Web 端不支援，已降級為 no-op（雙端矩陣 §通知）');
      _initialized = true;
      return;
    }
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: darwin),
    );
    _initialized = true;
  }

  Future<void> showLocal({
    required int id,
    required String title,
    required String body,
  }) async {
    if (kIsWeb) {
      appLogger.w('本機通知於 Web 端不支援，已忽略（雙端矩陣 §通知）');
      return;
    }
    const android = AndroidNotificationDetails(
      'rehab_local',
      '康復資料通知',
      importance: Importance.high,
      priority: Priority.high,
    );
    const darwin = DarwinNotificationDetails();
    await _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(android: android, iOS: darwin),
    );
  }

  // phase 2 預留：註冊遠端推送（FCM / APNs）。
  Future<void> registerPush() async {
    // TODO(phase2): 接後端推送服務，繫結裝置 token。
  }
}
