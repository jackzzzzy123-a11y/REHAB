// test/blur_filter_graph_test.dart
//
// B 影片模糊：純函式濾鏡圖建構器單測。
// 重點：濾鏡圖是跨平台模糊的唯一「邏輯核心」，抽離後可在無 ffmpeg.wasm / 無瀏覽器
//      的桌面 CI 完整驗證（避免 B 決策中「io 暫緩、Web 才能跑」導致的測試空洞）。

import 'package:flutter_test/flutter_test.dart';
import 'package:rehab_med/features/video_trim/blur_filter_graph.dart';

void main() {
  group('buildFaceRegionBlurArgs（預設參數）', () {
    final args = buildFaceRegionBlurArgs(
      inputName: 'input.mp4',
      outputName: 'output.mp4',
      start: const Duration(minutes: 1, seconds: 2, milliseconds: 3),
      end: const Duration(seconds: 5),
    );

    test('含輸入/輸出與裁剪時間戳', () {
      expect(args, containsAllInOrder(['-i', 'input.mp4']));
      expect(args, containsAllInOrder(['-ss', '00:01:02.003']));
      expect(args, containsAllInOrder(['-to', '00:00:05.000']));
      expect(args, contains('output.mp4'));
    });

    test('含 filter_complex 與編碼設定（mpeg4 / 去音軌）', () {
      final idx = args.indexOf('-filter_complex');
      expect(idx, isNonNegative);
      expect(args, containsAllInOrder(['-map', '[v]']));
      expect(args, contains('-an'));
      expect(args, containsAllInOrder(['-c:v', 'mpeg4']));
      expect(args, containsAllInOrder(['-pix_fmt', 'yuv420p']));
    });

    test('濾鏡圖：裁上緣 → 降採樣 → 升採樣(neighbor) → overlay', () {
      final graph = args[args.indexOf('-filter_complex') + 1];
      expect(
        graph,
        '[0:v]crop=iw:2*trunc(ih*0.34/2):0:0,'
        'scale=iw/20:-1,'
        'scale=iw*20:-1:flags=neighbor[face];'
        '[0:v][face]overlay=0:0[v]',
      );
    });
  });

  group('參數可調（topFraction / pixelBlock）', () {
    test('topFraction=0.5 → crop 高度 ih*0.50', () {
      final graph = facePixelationGraph(0.5, 20);
      expect(graph, contains('crop=iw:2*trunc(ih*0.50/2):0:0'));
    });

    test('pixelBlock=10 → scale iw/10 與 iw*10', () {
      final graph = facePixelationGraph(0.34, 10);
      expect(graph, contains('scale=iw/10:-1'));
      expect(graph, contains('scale=iw*10:-1:flags=neighbor'));
    });

    test('自訂參數會反映到 buildFaceRegionBlurArgs', () {
      final args = buildFaceRegionBlurArgs(
        inputName: 'i.mp4',
        outputName: 'o.mp4',
        start: Duration.zero,
        end: const Duration(seconds: 1),
        topFraction: 0.25,
        pixelBlock: 8,
      );
      final graph = args[args.indexOf('-filter_complex') + 1];
      expect(graph, contains('crop=iw:2*trunc(ih*0.25/2):0:0'));
      expect(graph, contains('scale=iw/8:-1'));
      expect(graph, contains('scale=iw*8:-1:flags=neighbor'));
    });
  });

  group('facePixelationGraph 輸出形狀', () {
    test('以 [v] 為最終輸出標籤', () {
      expect(facePixelationGraph(0.34, 20), endsWith('overlay=0:0[v]'));
    });
    test('臨時標籤 [face] 被定義與使用', () {
      final graph = facePixelationGraph(0.34, 20);
      expect(graph, contains('[face];'));
      expect(graph, contains('[0:v][face]overlay'));
    });
  });
}
