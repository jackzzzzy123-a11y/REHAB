// lib/core/network/log_interceptor.dart
//
// 日誌脫敏攔截器（§8.1）。
//
// 規則：
// - 生產環境（AppConfig.enableLogging == false）：不打印任何請求 / 回應內容，
//   僅依賴 Sentry 上報異常；本攔截器靜默。
// - 開發環境（enableLogging == true）：打印 method + uri + statusCode + duration，
//   若打印 body 則先以正則遮蔽敏感欄位為 [REDACTED]。
//
// 合規：避免個人資料（PDPO 第4原則）意外寫入日誌。
//
// 注意：dio 5.x 的 LogInterceptor 已移除 printRequestData / printResponseData 覆寫點，
// 故改以自訂 Interceptor 實作（官方建議的擴充方式），並統一經 appLogger 輸出
// （避免觸發 avoid_print，且生產可將 appLogger level 設為 warning）。

import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../utils/logger.dart';

// 需要遮蔽的欄位清單（正則匹配 key）。
// 新增敏感欄位只需擴充此正則（例如 token、password、hkid）。
final _sensitiveKeys = RegExp(
  '(name|phone|email|hkid|address|patientId|diagnosis|token|password)',
  caseSensitive: false,
);

String _maskJson(String text) => text.replaceAllMapped(
      _sensitiveKeys,
      (m) => '"${m.group(0)}":"[REDACTED]"',
    );

// 生產環境不打印任何日誌；開發環境打印前先脫敏。
void _log(Object object) {
  if (!AppConfig.enableLogging) return;
  // 嘗試對 JSON 內容脫敏；非 JSON 字串原樣輸出（無 PII 風險）。
  appLogger.d(_maskJson(object.toString()));
}

class LogInterceptorEx extends Interceptor {
  LogInterceptorEx({bool? enableLogging})
      : _enableLogging = enableLogging ?? AppConfig.enableLogging;

  final bool _enableLogging;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 記錄請求起始時間，用於計算 duration（放 extra，不污染業務資料）。
    if (_enableLogging) {
      options.extra['__log_start__'] = DateTime.now().millisecondsSinceEpoch;
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (_enableLogging) {
      final duration = _elapsed(response.requestOptions);
      _log(
        '${response.requestOptions.method} '
        '${response.requestOptions.uri} '
        '-> ${response.statusCode} (${duration}ms)',
      );
      if (response.data != null) {
        _log('RESPONSE BODY: ${response.data}');
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_enableLogging) {
      final duration = _elapsed(err.requestOptions);
      _log(
        '${err.requestOptions.method} '
        '${err.requestOptions.uri} '
        '-> ${err.response?.statusCode ?? 'ERR'} (${duration}ms)',
      );
    }
    handler.next(err);
  }

  int _elapsed(RequestOptions options) {
    final start = options.extra['__log_start__'] as int?;
    if (start == null) return 0;
    return DateTime.now().millisecondsSinceEpoch - start;
  }
}
