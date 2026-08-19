// lib/features/import/import_page.dart
//
// 匯入精靈頁（P1-3）。專家端路由 /doctor/import。
// 步驟：選檔 → 解析 → 驗證 → 入庫；完成後本機通知。
// 無障礙：字號跟隨系統、觸控目標 ≥ 48、錯誤以 liveRegion 播報。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rehab_med/l10n/generated/app_localizations.dart';

import 'providers/import_provider.dart';

class ImportPage extends ConsumerWidget {
  const ImportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(importProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.importTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StepIndicator(step: state.step, l10n: l10n),
            const SizedBox(height: 28),
            if (state.step == ImportStep.done)
              _SuccessBody(state: state, l10n: l10n)
            else if (state.step == ImportStep.error)
              _ErrorBody(
                state: state,
                l10n: l10n,
                onRetry: () =>
                    ref.read(importProvider.notifier).pickAndImport(),
              )
            else if (state.isBusy)
              _ProgressBody(step: state.step, l10n: l10n)
            else
              _IdleBody(
                l10n: l10n,
                onPick: () =>
                    ref.read(importProvider.notifier).pickAndImport(),
              ),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step, required this.l10n});
  final ImportStep step;
  final AppLocalizations l10n;

  int get _current {
    switch (step) {
      case ImportStep.picking:
        return 0;
      case ImportStep.parsing:
        return 1;
      case ImportStep.validating:
        return 2;
      case ImportStep.writing:
        return 3;
      case ImportStep.done:
        return 4;
      case ImportStep.idle:
      case ImportStep.error:
        return -1;
    }
  }

  String _label(int i) => switch (i) {
        0 => l10n.stepSelectFile,
        1 => l10n.stepParse,
        2 => l10n.stepValidate,
        3 => l10n.stepSave,
        _ => '',
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cur = _current;
    return Row(
      children: [
        for (var i = 0; i < 4; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 2,
                color: i <= cur ? scheme.primary : scheme.outline,
              ),
            ),
          Column(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: i < cur
                    ? scheme.primary
                    : (i == cur
                        ? scheme.primaryContainer
                        : scheme.surfaceContainerHighest),
                child: i < cur
                    ? Icon(Icons.check, size: 16, color: scheme.onPrimary)
                    : Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: i == cur
                              ? scheme.onPrimaryContainer
                              : scheme.onSurfaceVariant,
                        ),
                      ),
              ),
              const SizedBox(height: 4),
              Text(_label(i), style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ],
    );
  }
}

class _IdleBody extends StatelessWidget {
  const _IdleBody({required this.l10n, required this.onPick});
  final AppLocalizations l10n;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.upload_file, size: 48, color: scheme.primary),
                const SizedBox(height: 12),
                Text(l10n.importHint, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: onPick,
          icon: const Icon(Icons.folder_open),
          label: Text(l10n.pickFile),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
          ),
        ),
      ],
    );
  }
}

class _ProgressBody extends StatelessWidget {
  const _ProgressBody({required this.step, required this.l10n});
  final ImportStep step;
  final AppLocalizations l10n;

  String get _label => switch (step) {
        ImportStep.picking => l10n.stepSelectFile,
        ImportStep.parsing => l10n.stepParse,
        ImportStep.validating => l10n.stepValidate,
        ImportStep.writing => l10n.stepSave,
        _ => l10n.importing,
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          _label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({required this.state, required this.l10n});
  final ImportState state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final c = state.contract;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(Icons.check_circle, size: 56, color: scheme.primary),
        const SizedBox(height: 12),
        Text(
          l10n.importSuccess,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        if (c != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(l10n.importPatient(c.patient.displayName)),
                  const SizedBox(height: 8),
                  Text(l10n.importRecordCount(c.snapshots.length)),
                ],
              ),
            ),
          ),
        const SizedBox(height: 20),
        FilledButton.tonal(
          onPressed: () => context.go('/doctor'),
          child: Text(l10n.backToOverview),
        ),
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    required this.state,
    required this.l10n,
    required this.onRetry,
  });
  final ImportState state;
  final AppLocalizations l10n;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(Icons.error_outline, size: 56, color: scheme.error),
        const SizedBox(height: 12),
        Text(
          l10n.importFailed,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Semantics(
          liveRegion: true,
          child: Text(state.error ?? '', textAlign: TextAlign.center),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: Text(l10n.retry),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
          ),
        ),
      ],
    );
  }
}
