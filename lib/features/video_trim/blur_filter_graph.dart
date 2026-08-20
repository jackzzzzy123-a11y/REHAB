// lib/features/video_trim/blur_filter_graph.dart
//
// 臉部區域像素化濾鏡圖建構（純函式，可單測，不依賴 ffmpeg_wasm / dart:html）。
// 設計：只對畫面上方 topFraction 高度（通常為臉部）做方塊像素化，
//       其餘區域（身體動作）保持清晰，兼顧隱私保護與臨床動作檢視需求。
// 濾鏡：crop 取上緣區塊 → scale 降採樣 → scale 升採樣(neighbor) 產生方塊 → overlay 貼回原位。
// 編碼：mpeg4（ffmpeg.wasm 核心預設含此編碼器，跨平台一致；若核心缺此編碼器請改 libvpx→webm）。
// 注意：此檔案可在任意平台編譯與單測（無 web/IO 專屬依賴）。

import 'ffmpeg_time_format.dart';

/// 建構 ffmpeg 參數：剪輯 [start]→[end] 並對上方 [topFraction] 區域做像素化。
///
/// 回傳可直接餵給 ffmpeg.wasm `run()` 的參數陣列。
List<String> buildFaceRegionBlurArgs({
  required String inputName,
  required String outputName,
  required Duration start,
  required Duration end,
  double topFraction = 0.34,
  int pixelBlock = 20,
}) {
  final graph = facePixelationGraph(topFraction, pixelBlock);
  return [
    '-ss', formatFFmpegTimestamp(start),
    '-to', formatFFmpegTimestamp(end),
    '-i', inputName,
    '-filter_complex', graph,
    '-map', '[v]',
    '-an', // 隱私影片無需音軌
    '-c:v', 'mpeg4',
    '-q:v', '5',
    '-pix_fmt', 'yuv420p',
    outputName,
  ];
}

/// 臉部區域像素化濾鏡圖（輸出標籤 `v`）。
///
/// crop 高度強制為偶數（`2*trunc(ih*f/2)`），避免 yuv420p 下
/// 「height not divisible by 2」錯誤。
String facePixelationGraph(double topFraction, int pixelBlock) {
  final f = topFraction.toStringAsFixed(2);
  final p = pixelBlock;
  return '[0:v]crop=iw:2*trunc(ih*$f/2):0:0,'
      'scale=iw/$p:-1,'
      'scale=iw*$p:-1:flags=neighbor[face];'
      '[0:v][face]overlay=0:0[v]';
}
