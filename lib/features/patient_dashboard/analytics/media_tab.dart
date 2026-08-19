// lib/features/patient_dashboard/analytics/media_tab.dart
//
// 下鑽：輔助媒體（P1-4 樁）。P2 填充模糊縮圖（media_blur，p1_spec §12）。
// 合規：媒體須於存前模糊背景 + 面部；本 Tab 僅做「已模糊」視覺化與狀態徽標，
//       絕不嘗試還原或展示原始可辨識影像。
// 離線 demo 無原始位元組（storagePath 指向已加密之模糊媒體），故以磨砂占位表達「已模糊」。

import 'package:flutter/material.dart';
import 'package:rehab_med/l10n/generated/app_localizations.dart';

import '../../../data/models/media_asset.dart';

String _fmt(DateTime d) => '${d.year}-${d.month}-${d.day}';

class MediaTab extends StatelessWidget {
  const MediaTab({required this.media, super.key});
  final List<MediaAsset> media;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (media.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            Text(l10n.noMedia),
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // 合規提示：媒體存前已模糊，本 App 不留存原始影像。
        const _ComplianceNote(),
        const SizedBox(height: 12),
        for (final m in media) _MediaCard(media: m),
      ],
    );
  }
}

/// 合規說明條：媒體已於儲存前模糊背景 + 面部（PDPO / media_blur）。
class _ComplianceNote extends StatelessWidget {
  const _ComplianceNote();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.privacy_tip_outlined,
            size: 18,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '輔助媒體已於儲存前模糊背景與面部，本機不留存原始可辨識影像'
              '（PDPO 第4原則 / media_blur）。',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// 單筆媒體卡：模糊縮圖占位 + 元資訊 + 模糊狀態徽標。
class _MediaCard extends StatelessWidget {
  const _MediaCard({required this.media});
  final MediaAsset media;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isVideo = media.kind == MediaKind.video;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 模糊縮圖占位（離線 demo：無原始位元組，以磨砂視覺表達「已模糊」）。
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.surfaceContainerHighest,
                    scheme.primaryContainer,
                    scheme.secondaryContainer,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isVideo ? Icons.videocam : Icons.blur_on,
                      size: 40,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isVideo ? '影片 · 已模糊' : '影像 · 已模糊',
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(media.assetId, style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  '${media.kind.name} · ${_fmt(media.capturedAt)}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _BlurBadge(label: '背景已模糊', on: media.backgroundBlurred),
                    _BlurBadge(label: '面部已模糊', on: media.faceBlurred),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 模糊狀態徽標：已模糊=主色勾選；未模糊=錯誤色警示（合規異常）。
class _BlurBadge extends StatelessWidget {
  const _BlurBadge({required this.label, required this.on});
  final String label;
  final bool on;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = on ? scheme.primary : scheme.error;
    final bg = on ? scheme.primaryContainer : scheme.errorContainer;
    return Chip(
      visualDensity: VisualDensity.compact,
      avatar: Icon(
        on ? Icons.check_circle_outline : Icons.cancel_outlined,
        size: 16,
        color: color,
      ),
      label: Text(label),
      backgroundColor: bg.withValues(alpha: 0.25),
    );
  }
}
