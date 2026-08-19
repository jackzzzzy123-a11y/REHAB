// lib/features/patient_dashboard/providers/dashboard_providers.dart
//
// P1-4 專家儀表板依賴注入。
// - patientsProvider：當前專家綁定患者（來自加密儲存，RBAC 已隔）。
// - snapshotsProvider / mediaProvider：按 patientId 取該患者快照 / 媒體。
// - demoSeedNotifierProvider：一鍵載入內置種子，載入後 invalidate 患者列表刷新。
// 特徵層以 ref.watch(...).when(...) 消費，import / seed 後 invalidate 即刷新。

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/media_asset.dart';
import '../../../data/models/patient_profile.dart';
import '../../../data/models/rehab_snapshot.dart';
import '../../../data/providers/rehab_providers.dart';
import '../data/demo_seed.dart';

/// 綁定患者列表（來源：加密儲存）。
final patientsProvider =
    FutureProvider<List<PatientProfile>>((ref) async {
  final repo = await ref.watch(rehabRepositoryProvider.future);
  return repo.getActivePatients();
});

/// 單一患者的全部快照（按 testDate 升序，來源：加密儲存）。
final snapshotsProvider =
    FutureProvider.family<List<RehabSnapshot>, String>((ref, patientId) async {
  final repo = await ref.watch(rehabRepositoryProvider.future);
  return repo.getSnapshots(patientId);
});

/// 單一患者的輔助媒體（P2 填充，現為空）。
final mediaProvider =
    FutureProvider.family<List<MediaAsset>, String>((ref, patientId) async {
  final repo = await ref.watch(rehabRepositoryProvider.future);
  return repo.getMedia(patientId);
});

/// demo 種子載入狀態。
class DemoSeedState {
  const DemoSeedState({this.isLoading = false, this.error});
  final bool isLoading;
  final String? error;

  DemoSeedState copyWith({bool? isLoading, String? error}) => DemoSeedState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class DemoSeedNotifier extends StateNotifier<DemoSeedState> {
  DemoSeedNotifier(this._ref) : super(const DemoSeedState());
  final Ref _ref;

  Future<void> load() async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = await _ref.read(rehabRepositoryProvider.future);
      await loadDemoSeed(repo);
      // 載入後刷新患者列表（與真實匯入同源）。
      _ref.invalidate(patientsProvider);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return;
    }
    state = state.copyWith(isLoading: false);
  }
}

final demoSeedNotifierProvider =
    StateNotifierProvider<DemoSeedNotifier, DemoSeedState>((ref) {
  return DemoSeedNotifier(ref);
});

/// 患者清單搜尋關鍵字（自 dashboard 遷入，供 UI 狀態與元件解耦）。
final patientQueryProvider = StateProvider<String>((ref) => '');
