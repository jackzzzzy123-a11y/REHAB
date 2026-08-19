// lib/features/communication/communication_page.dart
//
// 醫患溝通（佔位）。安全圖文/音視頻；相機/麥克風按需請求並說明用途。
// 合規：如涉遙距醫療，須符合香港醫委會《遠程醫療實務道德規範指引》。

import 'package:flutter/material.dart';

class CommunicationPage extends StatelessWidget {
  const CommunicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('醫患溝通（佔位）')),
    );
  }
}
