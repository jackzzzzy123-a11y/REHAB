// lib/data/datasources/remote/api_client.dart
//
// 遠端資料源（包裝 dio）。實際請求經 core/network/dio_client 的攔截器鏈。
// 合規：傳輸層啟用證書綁定與日誌脫敏（§8.1 / §8.2）。

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehab_med/core/network/dio_client.dart';

class ApiClient {
  ApiClient(this._dio);
  final Dio _dio;

  Dio get dio => _dio;

  // TODO: 實作各 API 呼叫（依後端 Spring Boot 契約）
}

/// 遠端資料源 Provider。
final apiClientProvider = Provider<ApiClient>((Ref<ApiClient> ref) {
  return ApiClient(ref.watch(dioProvider));
});
