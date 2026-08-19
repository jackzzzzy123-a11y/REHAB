// lib/features/patient_dashboard/analytics/media_tab.dart
//
// 下鑽：輔助媒體（P1-4 樁）。P2 才填充模糊縮圖；現階段僅列出（脫敏提示）。
// 合規：媒體須於存前模糊背景 + 面部（media_blur，P2 實作）。

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
            const Icon(Icons.image_not_supported,
                size: 48, color: Colors.grey,),
            const SizedBox(height: 8),
            Text(l10n.noMedia),
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final m in media)
          ListTile(
            leading: const Icon(Icons.image),
            title: Text(m.assetId),
            subtitle: Text('${m.kind.name} · ${_fmt(m.capturedAt)}'),
          ),
      ],
    );
  }
}
