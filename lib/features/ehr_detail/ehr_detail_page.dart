// lib/features/ehr_detail/ehr_detail_page.dart
//
// 電子檔案詳情（佔位）。整合個人資訊/就診/檢查/評估/隨訪，以 Tab 或手風琴分類。
// 合規：醫健通資料僅作參考用途；展示前須確認取覽同意。

import 'package:flutter/material.dart';

class EhrDetailPage extends StatelessWidget {
  const EhrDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('電子檔案詳情（佔位）')),
    );
  }
}
