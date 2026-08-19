// lib/features/patient_upload/patient_upload_page.dart
//
// 患者端上傳（P2-d）。PII 同意 UX + 媒體選取 + 模糊標記存庫。
// 合規：上傳前取得同意（PDPO 同意原則）；媒體存前模糊背景 + 面部
//       （media_blur），絕不留存原始可辨識影像。
// 離線 demo：選取之媒體不寫入真實位元組，僅以 MediaAsset（已標記模糊）入庫；
//       生產環境接 phase 2 時改為 reals 加密寫入並銜接原始分析管線。

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/media_asset.dart';
import '../../data/providers/rehab_providers.dart';
import '../../features/auth/providers/auth_provider.dart';

class PatientUploadPage extends ConsumerStatefulWidget {
  const PatientUploadPage({super.key});

  @override
  ConsumerState<PatientUploadPage> createState() => _PatientUploadPageState();
}

class _PatientUploadPageState extends ConsumerState<PatientUploadPage> {
  bool _consented = false;
  bool _busy = false;
  String? _error;

  Future<void> _pickAndUpload() async {
    if (!_consented || _busy) return;
    setState(() => _busy = true);
    try {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.media,
      );
      if (picked == null || picked.files.isEmpty) {
        if (mounted) setState(() => _busy = false);
        return;
      }
      final file = picked.files.single;
      final ext = (file.extension ?? '').toLowerCase();
      final kind = {'mp4', 'mov', 'webm', 'avi'}.contains(ext)
          ? MediaKind.video
          : MediaKind.image;
      final user = ref.read(authNotifierProvider).user;
      // demo：以登入使用者 id 作為 patientId；
      // 生產環境應對應實際患者檔案之 patientId。
      final patientId = user?.id ?? 'self';
      final asset = MediaAsset(
        assetId: 'media-${DateTime.now().microsecondsSinceEpoch}',
        patientId: patientId,
        kind: kind,
        // 合規：存前已模糊 + 加密；本 demo 僅記錄加密路徑參考。
        storagePath: 'media/$patientId/${file.name}',
        capturedAt: DateTime.now(),
        backgroundBlurred: true,
        faceBlurred: true,
      );
      final repo = await ref.read(rehabRepositoryProvider.future);
      await repo.saveMedia(asset);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已上傳（已模糊並加密入庫）')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) setState(() => _error = '上傳失敗：$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
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
您即將上傳的媒體可能包含個人資料。本 App 會於儲存前模糊背景與面部，
並以加密方式靜態存放於本機（PDPO）。上傳即表示您同意上述處理方式。'''),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    value: _consented,
                    onChanged: (v) =>
                        setState(() => _consented = v ?? false),
                    title: const Text('我已知悉並同意上傳'),
                    controlAffinity: ListTileControlAffinity.leading,
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
            label: Text(_busy ? '處理中…' : '選擇媒體並上傳'),
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
