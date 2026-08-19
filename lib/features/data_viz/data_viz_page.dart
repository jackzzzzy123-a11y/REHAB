// lib/features/data_viz/data_viz_page.dart
//
// 數據可視化（佔位）。fl_chart 展示生命體徵 / 康復訓練趨勢。
// 合規：圖表數據須基於真實來源；不臆造或竄改（推測值須標註「待核實」）。

import 'package:flutter/material.dart';

class DataVizPage extends StatelessWidget {
  const DataVizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('數據可視化（佔位）')),
    );
  }
}
