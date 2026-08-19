// test/offline_reopen_semantic_test.dart
//
// 「離線重開」應用層語義驗證（VM 可跑，沙箱兼容）。
// 语义：写入 → box.close()（落盘/落库）→ 重新 openBox（模拟"重开"重载）→ 数据仍在。
// 配合 webverify/verify_idb.js（浏览器 IndexedDB 跨会话持久化）+ 用户手验（App 行为层），
// 三层证据链共同证明 spec §16「離線重開仍在」。
//
// 注：VM 测试用 Hive 默認文件 backend（寫入臨時目錄），與 Web 的 IndexedDB backend
// 共用同一套 Hive API 語義——close 後 reopen 的「持久化承諾」在此驗證應用層邏輯。

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() {
    // 每次测试独立临时目录，避免污染
    tempDir = Directory.systemTemp.createTempSync('hive_reopen_test_');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    if (Hive.isBoxOpen('reopen_probe')) {
      await Hive.box<Map<dynamic, dynamic>>('reopen_probe').close();
    }
    try {
      tempDir.deleteSync(recursive: true);
    } catch (_) {}
  });

  testWidgets('離線重開語義：寫入→關閉→重開→資料仍在（Hive API 層）', (tester) async {
    await tester.runAsync(() async {
      // 1) 打开 box 并写入一条患者数据（对应 App「載入範例」落盘路径）
      final box = await Hive.openBox<Map<dynamic, dynamic>>('reopen_probe');
      await box.put('P-1001', {
        'patientId': 'P-1001',
        'displayName': '床號 A-12 · 匿稱「康」',
        'rehabStage': 'recovering',
      });
      expect(box.length, 1, reason: '寫入後應有 1 條');

      // 2) 模拟「關閉」：close box（数据落盘）
      await box.close();
      expect(Hive.isBoxOpen('reopen_probe'), isFalse, reason: '關閉後 box 不應保持開啟');

      // 3) 模拟「重開」：重新 openBox（从磁盘/IndexedDB 重新加载）
      final reopened =
          await Hive.openBox<Map<dynamic, dynamic>>('reopen_probe');

      // 4) 断言数据仍在（核心验收点）
      expect(reopened.length, 1, reason: '重開後資料應仍在（離線重開）');
      final value = reopened.get('P-1001');
      expect(value, isNotNull);
      expect(value!['patientId'], 'P-1001');
      expect(value['displayName'], '床號 A-12 · 匿稱「康」');
      expect(value['rehabStage'], 'recovering');

      await reopened.close();
    });
  });
}
