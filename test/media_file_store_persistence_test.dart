// test/media_file_store_persistence_test.dart
//
// P3 持久化守門：媒體檔案必須「真實落盤」（P0 合規鐵律，非僅存 JSON 元數據）。
// 透過注入臨時 baseDirectory 的 MediaFileStoreIo 驗證：位元組一致、路徑 schema、
// 複製（非移動）、跨患者隔離。不觸發平台通道（baseDirectory 已注入）。

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_med/core/storage/media_file_store_io.dart';

void main() {
  group('MediaFileStoreIo 真實持久化', () {
    late Directory base;
    late MediaFileStoreIo store;

    setUp(() {
      base = Directory.systemTemp.createTempSync('media_store_test_');
      store = MediaFileStoreIo(baseDirectory: base);
    });

    tearDown(() {
      if (base.existsSync()) base.deleteSync(recursive: true);
    });

    test('persist 複製到 base/media/<patientId>/<fileName> 且位元組完全一致',
        () async {
      final src = File('${base.path}/src.mp4')..writeAsBytesSync([1, 2, 3, 4, 5]);
      final path = await store.persist(
        patientId: 'P1',
        fileName: 'clip.mp4',
        sourcePath: src.path,
      );

      // 回傳非空且路徑符合 schema。
      expect(path, isNotNull);
      expect(path, contains('${base.path}/media/P1/clip.mp4'));

      // 真實落盤（合規鐵律：檔案必須真的存在於檔案系統）。
      final out = File(path!);
      expect(out.existsSync(), isTrue);
      expect(out.readAsBytesSync(), [1, 2, 3, 4, 5]);

      // 複製而非移動：來源仍保留。
      expect(src.existsSync(), isTrue);
    });

    test('不同 patientId 落於各自資料夾且互不干擾', () async {
      final srcA = File('${base.path}/a.mp4')..writeAsBytesSync([9]);
      final srcB = File('${base.path}/b.mp4')..writeAsBytesSync([8]);

      final pa = await store.persist(
        patientId: 'PA',
        fileName: 'a.mp4',
        sourcePath: srcA.path,
      );
      final pb = await store.persist(
        patientId: 'PB',
        fileName: 'b.mp4',
        sourcePath: srcB.path,
      );

      expect(pa, contains('media/PA/a.mp4'));
      expect(pb, contains('media/PB/b.mp4'));
      expect(File(pa!).existsSync(), isTrue);
      expect(File(pb!).existsSync(), isTrue);
      expect(File(pa).readAsBytesSync(), [9]);
      expect(File(pb).readAsBytesSync(), [8]);
    });

    test('同名檔案重複 persist 覆寫而非失敗', () async {
      final src1 = File('${base.path}/v.mp4')..writeAsBytesSync([1, 1]);
      final src2 = File('${base.path}/v2.mp4')..writeAsBytesSync([2, 2, 2]);
      await store.persist(patientId: 'P1', fileName: 'v.mp4', sourcePath: src1.path);
      final p2 = await store.persist(
        patientId: 'P1',
        fileName: 'v.mp4',
        sourcePath: src2.path,
      );
      expect(File(p2!).readAsBytesSync(), [2, 2, 2]);
    });
  });
}
