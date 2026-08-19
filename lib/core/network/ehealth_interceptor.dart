// lib/core/network/ehealth_interceptor.dart
//
// 醫健通（eHealth）對接預留插槽（§8.3）。
//
// ⚠️ 待醫健通對接規範確認後實作，目前為空實作。
// 預計職責：
// - 附加 eSC / ELSA 連線標頭
// - 依「有需要知道」原則附帶取覽原因（reason for access）
// - 特殊限制紀錄需另取得病人額外同意
//
// 合規禁忌：未經病人明確及知情同意，不得實作取覽或互通其電子健康紀錄。
// 參考：《電子健康紀錄互通系統條例》（第625章）及相關實務守則。

import 'package:dio/dio.dart';

class EHealthInterceptor extends Interceptor {
  // TODO: 待醫健通對接規範（ELSA / eSC）確認後實作。
}
