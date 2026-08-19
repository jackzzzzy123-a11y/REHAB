// lib/app/security/lock_providers.dart
//
// 安全鎖狀態（#13 / P1-7）。前台切回 / 超時後重驗（local_auth 生物辨識 + 密碼兜底）。
// 規格 §10：超時預設 3 分鐘、可設定；鎖整個 App（進任意頁前先驗證）；重驗不另設獨立鎖。
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 安全鎖開關（設定可關閉）。
final lockEnabledProvider = StateProvider<bool>((ref) => true);

/// 鎖定逾時（預設 3 分鐘，可設定）。
final lockTimeoutProvider = StateProvider<Duration>(
  (ref) => const Duration(minutes: 3),
);

class LockState {
  const LockState({required this.locked, this.lastActiveAt});
  final bool locked;
  final DateTime? lastActiveAt;
}

/// 鎖定控制器：記錄最近活動時間，前台切回時判斷是否逾時上鎖。
class LockController extends StateNotifier<LockState> {
  LockController() : super(const LockState(locked: false));

  /// 登入 / 解鎖後刷新活動時間。[at] 供測試注入（預設 DateTime.now()）。
  void recordActivity({DateTime? at}) {
    state = LockState(
      locked: false,
      lastActiveAt: at ?? DateTime.now(),
    );
  }

  /// App 回到前台：距上次活動 ≥ timeout 則上鎖。
  /// [at] 供測試注入時間（預設 DateTime.now()）。
  void onResume({required Duration timeout, DateTime? at}) {
    final current = at ?? DateTime.now();
    final last = state.lastActiveAt;
    final idle =
        last == null ? Duration.zero : current.difference(last);
    state = LockState(
      locked: idle >= timeout,
      lastActiveAt: current,
    );
  }

  /// 生物辨識 / 密碼驗證通過後解鎖。
  void unlock() => recordActivity();
}

final lockControllerProvider =
    StateNotifierProvider<LockController, LockState>((ref) {
  return LockController();
});
