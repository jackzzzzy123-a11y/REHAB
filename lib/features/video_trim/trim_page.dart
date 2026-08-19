// lib/features/video_trim/trim_page.dart
//
// 影片剪輯頁（P3，三端共享 UI）。
// 流程：選檔後進入 → 預覽（video_player）→ 拖動起止（RangeSlider）
//      → 導出（引擎分派：移動端 video_trimmer / Web ffmpeg_wasm）
//      → 以 TrimResult 回傳給上傳流程。
// 合規：僅剪輯，不做模糊（視頻模糊暫緩，見 p1_spec §12 討論）。

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'preview_io.dart'
    if (dart.library.html) 'preview_web.dart' as preview;
import 'video_trimmer_engine.dart';

/// 剪輯頁：接收已選影片來源，回傳 [TrimResult]（null = 取消）。
class TrimPage extends StatefulWidget {
  const TrimPage({
    required this.source,
    required this.fileName,
    super.key,
  });

  /// 移動端：檔案路徑字串；Web：位元組陣列。
  final Object source;

  final String fileName;

  @override
  State<TrimPage> createState() => _TrimPageState();
}

class _TrimPageState extends State<TrimPage> {
  late final VideoTrimmerEngine _engine;
  VideoPlayerController? _controller;
  Duration _total = Duration.zero;
  Duration _start = Duration.zero;
  Duration _end = Duration.zero;
  bool _ready = false;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _engine = createTrimEngine(
      source: widget.source,
      fileName: widget.fileName,
    );
    unawaited(_prepare());
  }

  Future<void> _prepare() async {
    try {
      final total = await _engine.probeDuration();
      final ctrl = await preview.createPreviewController(
        source: widget.source,
        fileName: widget.fileName,
      );
      await ctrl.initialize();
      if (!mounted) {
        unawaited(ctrl.dispose());
        return;
      }
      setState(() {
        _total = total;
        _end = total;
        _controller = ctrl;
        _ready = true;
      });
    } catch (e) {
      if (mounted) setState(() => _error = '影片載入失敗：$e');
    }
  }

  Future<void> _export() async {
    if (_busy || _start >= _end) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await _engine.trim(
        TrimRequest(start: _start, end: _end),
      );
      if (!mounted) return;
      Navigator.of(context).pop(result);
    } catch (e) {
      if (mounted) setState(() => _error = '剪輯失敗：$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _togglePlay() {
    final ctrl = _controller;
    if (ctrl == null || !_ready) return;
    if (ctrl.value.isPlaying) {
      unawaited(ctrl.pause());
    } else {
      unawaited(ctrl.seekTo(_start));
      unawaited(ctrl.play());
    }
  }

  String _fmt(Duration d) {
    String two(int v) => v.toString().padLeft(2, '0');
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));
    return '${d.inHours > 0 ? '${d.inHours}:' : ''}$m:$s';
  }

  String _sizeLabel(int bytes) {
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / 1024).toStringAsFixed(0)} KB';
  }

  @override
  void dispose() {
    unawaited(_controller?.dispose());
    _engine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalSec = _total.inSeconds.toDouble();
    final startSec = _start.inMilliseconds / 1000;
    final endSec = _end.inMilliseconds / 1000;
    final sliderEnabled = _ready && totalSec > 0;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: '返回',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('剪輯影片'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPreview(),
          const SizedBox(height: 16),
          _buildInfo(),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '選擇要保留的片段（去掉開頭/結尾無意義部分）',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  if (!sliderEnabled)
                    const Text('無法讀取影片時長，無法剪輯。')
                  else ...[
                    RangeSlider(
                      values: RangeValues(
                        startSec.clamp(0, totalSec),
                        endSec.clamp(0, totalSec),
                      ),
                      max: totalSec,
                      labels: RangeLabels(_fmt(_start), _fmt(_end)),
                      onChanged: sliderEnabled
                          ? (values) => setState(() {
                                _start = Duration(
                                  milliseconds:
                                      values.start.round() * 1000,
                                );
                                _end = Duration(
                                  milliseconds:
                                      values.end.round() * 1000,
                                );
                              })
                          : null,
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_fmt(_start)),
                        const Text('→'),
                        Text(_fmt(_end)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_error != null) ...[
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
          ],
          FilledButton.icon(
            onPressed: (_ready && !_busy && _start < _end)
                ? _export
                : null,
            icon: _busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.content_cut),
            label: Text(_busy ? '剪輯中…' : '剪輯並上傳'),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    final ctrl = _controller;
    if (ctrl == null) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return AspectRatio(
      aspectRatio: ctrl.value.aspectRatio == 0
          ? 16 / 9
          : ctrl.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(ctrl),
          IconButton.filled(
            onPressed: _togglePlay,
            icon: Icon(
              ctrl.value.isPlaying ? Icons.pause : Icons.play_arrow,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    final trimmed = _end - _start;
    final inputBytes = _engine.inputBytes;
    return Row(
      children: [
        _InfoChip(label: '總時長', value: _fmt(_total)),
        const SizedBox(width: 8),
        _InfoChip(label: '剪輯後', value: _fmt(trimmed)),
        const SizedBox(width: 8),
        _InfoChip(
          label: '原始大小',
          value: inputBytes > 0 ? _sizeLabel(inputBytes) : '—',
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
