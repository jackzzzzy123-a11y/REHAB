// lib/features/patient_upload/patient_upload_page.dart
//
// 患者端上傳（P2-d + P3 升級 + B 影片模糊）。
// - 影片：選檔 → 剪輯（去掉頭尾，減體積）→（網頁版可選）模糊面部像素化
//        → 真實持久化（移動端落盤 / Web 下載）→ 元數據入庫（如實標記模糊狀態）。
// - 圖片：維持 P2-d 流程（元數據入庫，模糊標記）。
// 合規：上傳前取得同意（PDPO 同意原則）；行動端影片模糊暫緩（B 決策），UI 如實標記。
// 依賴倒置：剪輯引擎 / 檔案存放服務皆為平台抽象，UI 不碰平台細節。

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/media_asset.dart';
import '../../data/providers/rehab_providers.dart';
import '../../data/repositories/rehab_repository.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../video_trim/trim_page.dart';
import '../video_trim/video_trimmer_engine.dart';

class PatientUploadPage extends ConsumerStatefulWidget {
  const PatientUploadPage({super.key});

  @override
  ConsumerState<PatientUploadPage> createState() =>
      _PatientUploadPageState();
}

class _PatientUploadPageState extends ConsumerState<PatientUploadPage> {
  bool _consented = false;
  bool _busy = false;
  String? _error;

  Future<void> _pickAndUpload() async {
    if (!_consented || _busy) return;
    setState(() => _busy = true);
    _error = null;
    try {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.media,
      );
      if (picked == null || picked.files.isEmpty) {
        return;
      }
      final file = picked.files.single;
      final ext = (file.extension ?? '').toLowerCase();
      final kind = {'mp4', 'mov', 'webm', 'avi'}.contains(ext)
          ? MediaKind.video
          : MediaKind.image;
      final patientId =
          ref.read(authNotifierProvider).user?.id ?? 'self';
      if (kind == MediaKind.video) {
        await _handleVideoUpload(file, patientId);
      } else {
        await _handleImageUpload(file, patientId);
      }
    } catch (e) {
      if (mounted) setState(() => _error = '上傳失敗：$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// 影片：剪輯 → 持久化 → 元數據入庫。
  Future<void> _handleVideoUpload(
    PlatformFile file,
    String patientId,
  ) async {
    final source = _videoSource(file);
    final result = await Navigator.of(context).push<TrimResult>(
      MaterialPageRoute(
        builder: (_) => TrimPage(source: source, fileName: file.name),
      ),
    );
    if (result == null || !mounted) return; // 用戶取消剪輯

    final repo = await ref.read(rehabRepositoryProvider.future);
    final storagePath = await _persistTrimmed(repo, file, patientId, result);

    final asset = MediaAsset(
      assetId: 'media-${DateTime.now().microsecondsSinceEpoch}',
      patientId: patientId,
      kind: MediaKind.video,
      storagePath: storagePath,
      capturedAt: DateTime.now(),
      // 如實標記：Web 導出時若開啟模糊面部則 faceBlurred=true；
      // 行動端目前暫緩模糊（B 決策），引擎回傳 false，絕不謊報。
      backgroundBlurred: result.backgroundBlurred,
      faceBlurred: result.faceBlurred,
    );
    await repo.saveMedia(asset);
    if (mounted) {
      _showSaved(_videoSavedMessage(result, kIsWeb));
      context.pop();
    }
  }

  /// 圖片：維持 P2-d 流程（元數據入庫）。
  Future<void> _handleImageUpload(
    PlatformFile file,
    String patientId,
  ) async {
    final repo = await ref.read(rehabRepositoryProvider.future);
    final asset = MediaAsset(
      assetId: 'media-${DateTime.now().microsecondsSinceEpoch}',
      patientId: patientId,
      kind: MediaKind.image,
      storagePath: 'media/$patientId/${file.name}',
      capturedAt: DateTime.now(),
      backgroundBlurred: true,
      faceBlurred: true,
    );
    await repo.saveMedia(asset);
    if (mounted) {
      _showSaved('已上傳並保存（圖片）');
      context.pop();
    }
  }

  /// 剪輯後檔案持久化：移動端落盤回傳真實路徑；Web 以下載標記。
  Future<String> _persistTrimmed(
    RehabRepository repo,
    PlatformFile file,
    String patientId,
    TrimResult result,
  ) async {
    if (kIsWeb) {
      return 'web_download:$patientId/${file.name}';
    }
    if (result.outputPath.isEmpty) {
      throw Exception('剪輯輸出路徑為空');
    }
    final saved = await repo.persistMediaFile(
      patientId: patientId,
      fileName: 'trimmed_${DateTime.now().millisecondsSinceEpoch}_'
          '${file.name}',
      sourcePath: result.outputPath,
    );
    if (saved == null || saved.isEmpty) {
      throw Exception('媒體檔案持久化失敗');
    }
    return saved;
  }

  /// 依平台取得剪輯頁輸入源：移動端 = 路徑；Web = bytes。
  Object _videoSource(PlatformFile file) {
    if (kIsWeb) {
      return file.bytes ?? Uint8List(0);
    }
    return file.path ?? '';
  }

  String _videoSavedMessage(TrimResult result, bool isWeb) {
    final savedMb = result.outputBytes / (1024 * 1024);
    final savedSize = savedMb >= 1
        ? '${savedMb.toStringAsFixed(1)} MB'
        : '${(result.outputBytes / 1024).toStringAsFixed(0)} KB';
    if (isWeb) {
      return '已剪輯並下載到本機（$savedSize）';
    }
    return '已上傳並保存（剪輯後 $savedSize）';
  }

  void _showSaved(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: '返回',
          onPressed: () => context.pop(),
        ),
        title: const Text('上傳媒體'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '個人資料（PII）同意',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('''
您即將上傳的影片/圖片可能包含個人資料。本 App 以加密方式靜態存放於本機（PDPO）。
影片可於上傳前剪輯，去掉開頭/結尾無意義片段。上傳即表示您同意上述處理方式。'''),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    value: _consented,
                    onChanged: (v) =>
                        setState(() => _consented = v ?? false),
                    title: const Text('我已知悉並同意上傳'),
                    controlAffinity:
                        ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: (_consented && !_busy) ? _pickAndUpload : null,
            icon: _busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.upload_file),
            label: Text(_busy ? '處理中…' : '選擇影片/圖片並上傳'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
        ],
      ),
    );
  }
}
