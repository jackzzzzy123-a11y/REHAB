// lib/data/datasources/api_data_source.dart
//
// 後端 API 資料源樁（phase 2 預留）。融合期由 SyncService 接上。
// 現階段（純本地 demo）不啟用；介面與 FileImportDataSource 一致，便於日後切換。

import '../../data/models/import_batch.dart';
import 'rehab_data_source.dart';

class ApiDataSource implements RehabDataSource {
  const ApiDataSource();
  @override
  Future<ImportContract> importFileContent(
    String content,
    ImportFormat format,
  ) {
    throw UnimplementedError('後端 API 資料源待 phase 2 實作（SyncService 預留）');
  }
}
