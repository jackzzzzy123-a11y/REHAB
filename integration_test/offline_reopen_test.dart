// integration_test/offline_reopen_test.dart
//
// Web「离线重开」验收：在真实浏览器（Edge）中验证 Hive 走 IndexedDB 的持久化。
// 语义：写入 → box.close()（数据落 IndexedDB）→ 重新 openBox（模拟"重开"从 IndexedDB 重载）
//       → 断言数据仍在。加上 webverify/verify_idb.js（真实关闭浏览器重开探针仍恢复），
//       两层证据共同证明「離線重開仍在」验收成立。
//
// 运行方式（在真实浏览器上跑，非 VM）：
//   flutter test -d edge integration_test/offline_reopen_test.dart
//   （Edge 由 Flutter device 发现；或 flutter drive + msedgedriver）

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Web 離線重開：Hive IndexedDB 寫入→關閉→重開→資料仍在', (tester) async {
    // 真实 IO（IndexedDB）必须包 runAsync，否则 FakeAsync 死锁
    await tester.runAsync(() async {
      // 1) 初始化 Hive（web 端 backend = IndexedDB）
      await Hive.initFlutter();

      // 2) 清理上次残留（幂等）
      if (Hive.isBoxOpen('reopen_probe')) {
        await Hive.box<Map<dynamic, dynamic>>('reopen_probe').close();
      }
      await Hive.deleteBoxFromDisk('reopen_probe');

      // 3) 打开 box 并写入一条患者数据（对应 App 中「載入範例」落盘路径）
      final box = await Hive.openBox<Map<dynamic, dynamic>>('reopen_probe');
      await box.put('P-1001', {
        'patientId': 'P-1001',
        'displayName': '床號 A-12 · 匿稱「康」',
        'rehabStage': 'recovering',
      });
      expect(box.length, 1, reason: '寫入後應有 1 條');

      // 4) 模拟「關閉」：close box → 数据落 IndexedDB
      await box.close();
      expect(Hive.isBoxOpen('reopen_probe'), isFalse, reason: '關閉後 box 不應保持開啟');

      // 5) 模拟「重開」：重新 openBox → 从 IndexedDB 重新加载
      final reopened =
          await Hive.openBox<Map<dynamic, dynamic>>('reopen_probe');

      // 6) 断言数据仍在（核心验收点）
      expect(reopened.length, 1, reason: '重開後資料應仍在（離線重開）');
      final value = reopened.get('P-1001');
      expect(value, isNotNull);
      expect(value!['patientId'], 'P-1001');
      expect(value['displayName'], '床號 A-12 · 匿稱「康」');
      expect(value['rehabStage'], 'recovering');

      // 7) 收尾：关闭并删除测试盒
      await reopened.close();
      await Hive.deleteBoxFromDisk('reopen_probe');
    });
  });
}
