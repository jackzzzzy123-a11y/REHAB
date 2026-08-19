// lib/features/communication/providers/communication_provider.dart
//
// 醫患溝通狀態（P2-c）。離線本地 App：對話存於記憶體（不跨裝置），
// 生產環境接 phase 2 後端時替換為 SyncService / NotificationService。
// 合規：相機/麥克風按需請求並說明用途（見 communication_page 的權限說明流程）；
//       如涉遠距醫療，須符合香港醫委會《遠程醫療實務道德規範指引》。
// 採用 plain class（非 freezed）以規避 build_runner，純前端展示足矣。

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 訊息種類：文字 / 圖像 / 影片（影片為 P2 占位，現階段僅文字傳送）。
enum MessageKind { text, image, video }

/// 單則訊息。sender 取語意值：'expert'（醫生）/ 'patient'（患者）/ 'system'（系統提示）。
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.at,
    this.kind = MessageKind.text,
  });

  final String id;
  final String sender;
  final String text;
  final DateTime at;
  final MessageKind kind;
}

final communicationProvider =
    StateNotifierProvider<CommunicationNotifier, List<ChatMessage>>((ref) {
  return CommunicationNotifier();
});

class CommunicationNotifier extends StateNotifier<List<ChatMessage>> {
  CommunicationNotifier()
      : super([
          ChatMessage(
            id: 'sys-0',
            sender: 'system',
            text: '本頻道為醫患溝通（本地離線）。涉及遠距醫療請遵守'
                '香港醫委會《遠程醫療實務道德規範指引》。',
            at: DateTime.now().subtract(const Duration(minutes: 5)),
          ),
        ]);

  /// 傳送一則訊息。空白內容忽略（不產生訊息）。
  void send({
    required String sender,
    required String text,
    MessageKind kind = MessageKind.text,
  }) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    state = [
      ...state,
      ChatMessage(
        id: 'm-${DateTime.now().microsecondsSinceEpoch}',
        sender: sender,
        text: trimmed,
        at: DateTime.now(),
        kind: kind,
      ),
    ];
  }
}
