// test/acceptance/acceptance_test.dart
//
// P1 驗收回歸（spec §16 沙箱可自動化部分）：
//   1. 資料流：匯入範例 → 患者入列 → 看板 provider 鏈可取資料
//   2. Hive 持久化：離線「重開」後資料仍在（加密盒）
//   3. 刪除：軟刪可查審計 + 硬刪(purge)連帶銷毀
//   4. 長者模式：字號/高對比/角色主題在 theme 層的斷言
// 平台依賴項（生物辨識/通知/選檔/視覺）→ 見 docs/acceptance_device_checklist.md。
import 'dart:io';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:rehab_med/app/theme/app_theme.dart';
import 'package:rehab_med/core/security/encryption.dart';
import 'package:rehab_med/core/storage/audit_store.dart';
import 'package:rehab_med/core/storage/deletion_service.dart';
import 'package:rehab_med/core/storage/local_storage_service.dart';
import 'package:rehab_med/data/datasources/file_import_data_source.dart';
import 'package:rehab_med/data/models/audit_entry.dart';
import 'package:rehab_med/data/providers/rehab_providers.dart';
import 'package:rehab_med/data/repositories/rehab_repository.dart';
import 'package:rehab_med/features/auth/domain/user_role.dart';
import 'package:rehab_med/features/patient_dashboard/data/demo_seed.dart';
import 'package:rehab_med/features/patient_dashboard/providers/dashboard_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() async {
    await Hive.close();
  });

  final testKey = encrypt.Key.fromUtf8('0123456789abcdef0123456789abcdef');

  Future<
      (
        LocalStorageService,
        DeletionService,
        AuditStore,
        RehabRepository,
        String,
      )> buildRepo() async {
    final dir = Directory.systemTemp.createTempSync('hive_acceptance');
    Hive.init(dir.path);
    final storage = LocalStorageService(Encryption(testKey));
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final deletion = DeletionService(storage: storage, prefs: prefs);
    final audit = AuditStore(storage);
    final dataSource = FileImportDataSource(storage: storage);
    final repo = RehabRepository(
      storage: storage,
      dataSource: dataSource,
      deletion: deletion,
      auditStore: audit,
      currentExpertId: 'DOC-0001',
    );
    return (storage, deletion, audit, repo, dir.path);
  }

  group('驗收 1：資料流（匯入 → 列表 → 看板 provider 鏈）', () {
    test('載入範例後，患者入列、快照按日期升序、匯入審計已記錄', () async {
      final (storage, _, audit, repo, _) = await buildRepo();
      await loadDemoSeed(repo);

      final patients = await repo.getActivePatients();
      expect(patients, isNotEmpty, reason: '範例應匯入至少 1 名患者');

      final first = patients.first;
      final snaps = await repo.getSnapshots(first.patientId);
      expect(snaps, isNotEmpty, reason: '患者應有快照');
      for (var i = 1; i < snaps.length; i++) {
        expect(
          snaps[i].testDate.isBefore(snaps[i - 1].testDate),
          isFalse,
          reason: '快照應依 testDate 升序',
        );
      }

      final auditList = await audit.forPatient(first.patientId);
      expect(
        auditList.where((e) => e.action == AuditAction.import),
        isNotEmpty,
        reason: '匯入動作應寫入審計',
      );
    });

    test('看板 provider 鏈（override repo）可取資料', () async {
      final (_, _, _, repo, _) = await buildRepo();
      await loadDemoSeed(repo);

      final container = ProviderContainer(
        overrides: [rehabRepositoryProvider.overrideWith((ref) async => repo)],
      );
      addTearDown(container.dispose);

      final providerPatients = await container.read(patientsProvider.future);
      expect(providerPatients, isNotEmpty);

      final first = providerPatients.first;
      final providerSnaps =
          await container.read(snapshotsProvider(first.patientId).future);
      expect(providerSnaps, isNotEmpty);
    });
  });

  group('驗收 2：離線重開仍在（Hive 加密盒持久化）', () {
    test('關閉並重建儲存後資料仍在', () async {
      final (storage, _, _, repo, dir) = await buildRepo();
      await loadDemoSeed(repo);
      final before = await storage.getActivePatients();
      expect(before, isNotEmpty);

      // 模擬 App 重開：關閉所有盒，以相同目錄 + 相同金鑰重建服務。
      await Hive.close();
      Hive.init(dir);
      final storage2 = LocalStorageService(Encryption(testKey));
      final after = await storage2.getActivePatients();
      expect(after.length, before.length, reason: '重開後患者應仍在');
      expect(
        await storage2.getSnapshotsForPatient(before.first.patientId),
        isNotEmpty,
        reason: '重開後快照應仍在',
      );
    });
  });

  group('驗收 3：刪除軟刪可查審計', () {
    test('軟刪過濾列表、PII 保留；硬刪連帶銷毀', () async {
      final (storage, deletion, audit, repo, _) = await buildRepo();
      await loadDemoSeed(repo);
      final patient = (await repo.getActivePatients()).first;

      // 審計已記錄（匯入）
      expect(await audit.forPatient(patient.patientId), isNotEmpty);

      // 軟刪：active 列表過濾，PII 仍在（isActive=false）
      await repo.softDeletePatient(patient.patientId);
      final active = await repo.getActivePatients();
      expect(
        active.where((p) => p.patientId == patient.patientId),
        isEmpty,
        reason: '軟刪後不應出現在 active 列表',
      );
      final kept = await storage.getPatient(patient.patientId);
      expect(kept, isNotNull);
      expect(kept!.isActive, isFalse);

      // 硬刪(purge)：患者 + 快照 + 審計一併銷毀
      await repo.purgePatient(patient.patientId);
      expect(await storage.getPatient(patient.patientId), isNull);
      expect(
        await storage.getSnapshotsForPatient(patient.patientId),
        isEmpty,
      );
      expect(await audit.forPatient(patient.patientId), isEmpty);
    });
  });

  group('驗收 4：長者模式 theme 層斷言', () {
    test('字號 / 高對比 / 角色強調色 / 明暗', () {
      final normal = AppTheme.forRole(UserRole.doctor);
      expect(normal.textTheme.bodyMedium?.fontSize, 16);

      final elder = AppTheme.forRole(UserRole.doctor, elder: true);
      expect(
        elder.textTheme.bodyMedium?.fontSize,
        20,
        reason: '長者模式基礎字號應加大',
      );

      final contrast =
          AppTheme.forRole(UserRole.patient, highContrast: true);
      expect(
        contrast.scaffoldBackgroundColor,
        Colors.white,
        reason: '高對比淺色背景應為純白',
      );

      final roleTheme = elder.extension<RoleTheme>();
      expect(roleTheme, isNotNull);
      expect(
        roleTheme!.accent,
        elder.colorScheme.primary,
        reason: '角色強調色應對應 scheme.primary',
      );

      final dark = AppTheme.forRole(
        UserRole.doctor,
        brightness: Brightness.dark,
      );
      expect(dark.brightness, Brightness.dark);
    });
  });
}
