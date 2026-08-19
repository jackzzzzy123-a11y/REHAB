// lib/app/localization/l10n.dart
//
// 多語切換 Provider（繁中 / 英文）。
// 合規：UI 文案以繁體中文為主，醫療術語使用標準譯名。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 預設繁體中文（香港）；使用者可於設定頁切換為英文。
final localeProvider = StateProvider<Locale>((ref) => const Locale('zh', 'HK'));
