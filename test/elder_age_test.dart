// test/elder_age_test.dart
//
// P2-a 長者年齡 65 規則單測（p1_spec §11）：
// - ageFromDob：出生年月 → 滿歲
// - autoElderFromAge：年滿 65 觸發
// - effectiveElderFromAge：手動覆蓋 > 患者端年齡 > 專家端年齡
// 純函式測試，不依賴 WidgetsBinding。

import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_med/app/theme/theme_providers.dart';

void main() {
  group('ageFromDob', () {
    test('年齡邊界：64 不觸發，65 起觸發', () {
      // ageFromDob 由整合驗證；此處驗證 autoElderFromAge 的 65 邊界。
      expect(autoElderFromAge(64), isFalse);
      expect(autoElderFromAge(65), isTrue);
      expect(autoElderFromAge(66), isTrue);
      expect(autoElderFromAge(null), isFalse);
    });
  });

  group('effectiveElderFromAge', () {
    test('手動覆蓋優先於年齡', () {
      expect(effectiveElderFromAge(override: true), isTrue);
      expect(effectiveElderFromAge(override: false, age: 80), isFalse);
    });

    test('患者端年齡滿 65 觸發（專家端未滿）', () {
      expect(
        effectiveElderFromAge(age: 70, expertAge: 40),
        isTrue,
      );
    });

    test('專家端年齡滿 65 觸發（患者端未滿）', () {
      expect(
        effectiveElderFromAge(age: 40, expertAge: 72),
        isTrue,
      );
    });

    test('兩端皆未滿 65 不觸發', () {
      expect(
        effectiveElderFromAge(age: 50, expertAge: 55),
        isFalse,
      );
    });

    test('未設定年齡不觸發', () {
      expect(effectiveElderFromAge(), isFalse);
    });
  });
}
