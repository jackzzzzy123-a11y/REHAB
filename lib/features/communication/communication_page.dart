// lib/features/communication/communication_page.dart
//
// 醫患溝通（P2-c）。安全圖文/音視頻；相機/麥克風按需請求並說明用途。
// 合規：如涉遠距醫療，須符合香港醫委會《遠程醫療實務道德規範指引》。
// 離線本地 App：對話存於記憶體（見 communication_provider），不跨裝置。
// 相機/麥克風權限：本 demo 不引入原生權限套件，改以「說明用途」對話框表達合規流程；
//       生產環境接 phase 2 時，於此處改接 permission_handler 並在使用前請求授權。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rehab_med/l10n/generated/app_localizations.dart';

import '../../features/auth/domain/user_role.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'providers/communication_provider.dart';

const String _cameraPermissionBody =
    '拍攝康復進度照片時，本 App 會於使用前請求相機權限，並於儲存前模糊背景與面部（media_blur）。本 demo 僅展示說明流程。';

const String _micPermissionBody =
    '語音留言時，本 App 會於使用前請求麥克風權限並說明用途。本 demo 僅展示說明流程。';

class CommunicationPage extends ConsumerStatefulWidget {
  const CommunicationPage({super.key});

  @override
  ConsumerState<CommunicationPage> createState() => _CommunicationPageState();
}

class _CommunicationPageState extends ConsumerState<CommunicationPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final role =
        ref.read(authNotifierProvider).user?.role ?? UserRole.patient;
    final sender = role == UserRole.doctor ? 'expert' : 'patient';
    ref
        .read(communicationProvider.notifier)
        .send(sender: sender, text: _controller.text);
    _controller.clear();
  }

  Future<void> _explainPermission(
    BuildContext context,
    String title,
    String body,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('瞭解'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final role =
        ref.watch(authNotifierProvider).user?.role ?? UserRole.patient;
    final mySender = role == UserRole.doctor ? 'expert' : 'patient';
    final messages = ref.watch(communicationProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: '返回',
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.contactDoctor),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            tooltip: '拍攝康復進度（說明用途）',
            onPressed: () => _explainPermission(
              context,
              '相機權限',
              _cameraPermissionBody,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic_none_outlined),
            tooltip: '錄音（說明用途）',
            onPressed: () => _explainPermission(
              context,
              '麥克風權限',
              _micPermissionBody,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
            child: Text(
              '本地離線對話 · 涉及遠距醫療請遵守香港醫委會相關指引',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              reverse: true,
              itemCount: messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final m = messages[messages.length - 1 - i];
                if (m.sender == 'system') {
                  return _SystemBubble(text: m.text);
                }
                return _MessageBubble(message: m, mine: m.sender == mySender);
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: '輸入訊息…',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onSubmitted: (_) => _send(),
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _send,
                    icon: const Icon(Icons.send),
                    tooltip: '傳送',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SystemBubble extends StatelessWidget {
  const _SystemBubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.mine});
  final ChatMessage message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final who =
        mine ? '我' : (message.sender == 'expert' ? '醫生' : '患者');
    final time =
        '${message.at.hour}:${message.at.minute.toString().padLeft(2, '0')}';
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: mine
              ? scheme.primaryContainer
              : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.text),
            const SizedBox(height: 2),
            Text(
              '$who · $time',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
