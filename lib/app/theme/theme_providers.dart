// lib/app/theme/theme_providers.dart
//
// 主題狀態 Provider（#9 明暗 / #10 長者模式）。
// 長者模式「自動 + 手動 + 可調」：
// - 自動：系統字體縮放 ≥1.3 時自動開啟（無 PII 依賴，立即可測）。
//   TODO(#10 P2)：依規格改為按年齡 ≥65 —— 患者端讀 PatientProfile.dateOfBirth，
//   專家端接用家年齡；拿到 PII 後把 autoElderFromSystem 換成年齡判斷即可。
// - 手動：elderOverrideProvider 強制開啟/關閉（null = 跟隨自動）。
// - 可調：字號倍率 / 高對比 / 簡化導航。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 明暗主題模式，預設跟隨系統。
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// 長者模式手動覆蓋：null = 跟隨自動；true/false = 強制開啟/關閉。
final elderOverrideProvider = StateProvider<bool?>((ref) => null);

/// 長者字號倍率（1.0–2.0，預設 1.25）。
final elderScaleProvider = StateProvider<double>((ref) => 1.25);

/// 高對比（M3 contrastLevel 拉滿 + 純色背景）。
final elderContrastProvider = StateProvider<bool>((ref) => false);

/// 簡化導航（隱藏次要入口，僅保留核心操作）。
final elderSimplifyProvider = StateProvider<bool>((ref) => false);

/// 依系統字體縮放判斷「自動長者」：比例 ≥1.3 視為長者偏好。
/// 用 platformDispatcher（context-free）：在 App 根（MaterialApp 之上）也能讀，
/// 且不會讀到 App 自身已套用的縮放（避免回授讓開關卡死）。
bool autoElderFromSystem() {
  final factor = WidgetsBinding.instance.platformDispatcher.textScaleFactor;
  return factor >= 1.3;
}

/// 生效中的長者模式：手動覆蓋 > 系統自動。純函式，易於測試。
bool effectiveElder({bool? override}) => override ?? autoElderFromSystem();
