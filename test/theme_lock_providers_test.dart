// test/theme_lock_providers_test.dart
//
// 冒烟单测：#9 主题 Provider 默认值 / #10 长者模式（自动+覆盖）/ #13 安全锁逾时逻辑。
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_med/app/security/lock_providers.dart';
import 'package:rehab_med/app/theme/theme_providers.dart';

void main() {
  // autoElderFromSystem 讀 WidgetsBinding.instance → 需先初始化 binding。
  TestWidgetsFlutterBinding.ensureInitialized();

  group('themeModeProvider (#9)', () {
    test('預設跟隨系統', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(themeModeProvider), ThemeMode.system);
    });

    test('可切換淺色/深色', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(themeModeProvider.notifier).state = ThemeMode.dark;
      expect(container.read(themeModeProvider), ThemeMode.dark);
    });
  });

  group('長者模式 providers (#10)', () {
    test('預設：未覆蓋、字號 1.25、高對比關、簡化導航關', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(elderOverrideProvider), isNull);
      expect(container.read(elderScaleProvider), 1.25);
      expect(container.read(elderContrastProvider), isFalse);
      expect(container.read(elderSimplifyProvider), isFalse);
    });

    test('手動覆蓋可強制開啟/關閉', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(elderOverrideProvider.notifier).state = true;
      expect(
        effectiveElder(override: container.read(elderOverrideProvider)),
        isTrue,
      );
      container.read(elderOverrideProvider.notifier).state = false;
      expect(
        effectiveElder(override: container.read(elderOverrideProvider)),
        isFalse,
      );
    });

    test('無手動覆蓋時跟隨自動（測試環境系統縮放 1.0 → false）', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      // 測試環境 platformDispatcher.textScaleFactor = 1.0 → 自動長者 false。
      expect(autoElderFromSystem(), isFalse);
      expect(effectiveElder(), isFalse);
    });
  });

  group('安全鎖 LockController (#13)', () {
    final base = DateTime(2026, 8, 18, 12);

    test('登入後未逾時不上鎖', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(lockControllerProvider.notifier).recordActivity(at: base);
      expect(container.read(lockControllerProvider).locked, isFalse);
    });

    test('前台切回逾時(≥3min)上鎖', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(lockControllerProvider.notifier)
        ..recordActivity(at: base)
        ..onResume(
          timeout: const Duration(minutes: 3),
          at: base.add(const Duration(minutes: 4)),
        );
      expect(container.read(lockControllerProvider).locked, isTrue);
    });

    test('前台切回未逾時不上鎖', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(lockControllerProvider.notifier)
        ..recordActivity(at: base)
        ..onResume(
          timeout: const Duration(minutes: 3),
          at: base.add(const Duration(minutes: 1)),
        );
      expect(container.read(lockControllerProvider).locked, isFalse);
    });

    test('解鎖後可恢復', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(lockControllerProvider.notifier)
        ..recordActivity(at: base)
        ..onResume(
          timeout: const Duration(minutes: 3),
          at: base.add(const Duration(minutes: 4)),
        );
      expect(container.read(lockControllerProvider).locked, isTrue);
      notifier.unlock();
      expect(container.read(lockControllerProvider).locked, isFalse);
    });
  });
}
