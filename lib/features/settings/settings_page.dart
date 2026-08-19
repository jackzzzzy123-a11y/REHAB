// lib/features/settings/settings_page.dart
//
// 設定（#9 外觀 / #10 長者模式 / #13 安全鎖入口）。
// 合規：字體縮放支援長者友善；語言切換支援繁中/英文。
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehab_med/app/security/lock_providers.dart';
import 'package:rehab_med/app/theme/theme_providers.dart';
import 'package:rehab_med/l10n/generated/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final elder = effectiveElder(
      override: ref.watch(elderOverrideProvider),
    );
    final override = ref.watch(elderOverrideProvider);
    final scale = ref.watch(elderScaleProvider);
    final contrast = ref.watch(elderContrastProvider);
    final simplify = ref.watch(elderSimplifyProvider);
    // #13 安全鎖
    final lockEnabled = ref.watch(lockEnabledProvider);
    final lockTimeout = ref.watch(lockTimeoutProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          // ── 外觀：明暗模式（#9）──
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l10n.themeTitle),
            subtitle: Text(l10n.themeSubtitle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(l10n.themeModeLight),
                  icon: const Icon(Icons.light_mode_outlined),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(l10n.themeModeDark),
                  icon: const Icon(Icons.dark_mode_outlined),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(l10n.themeModeSystem),
                  icon: const Icon(Icons.brightness_auto_outlined),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (selection) {
                ref.read(themeModeProvider.notifier).state = selection.first;
              },
            ),
          ),
          const Divider(height: 32),

          // ── 長者模式（#10）：自動 + 手動 + 可調 ──
          SwitchListTile(
            secondary: const Icon(Icons.accessibility_new_outlined),
            title: Text(l10n.elderTitle),
            subtitle: Text(l10n.elderSubtitle),
            value: elder,
            onChanged: (v) {
              ref.read(elderOverrideProvider.notifier).state = v;
            },
          ),
          if (override == null)
            ListTile(
              dense: true,
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.elderAutoHint),
            )
          else
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextButton.icon(
                  onPressed: () {
                    ref.read(elderOverrideProvider.notifier).state = null;
                  },
                  icon: const Icon(Icons.restart_alt),
                  label: Text(l10n.elderResetAuto),
                ),
              ),
            ),
          // 專家端長者模式：年滿 65 自動套用（p1_spec §11 專家端語義）
          ListTile(
            leading: const Icon(Icons.cake_outlined),
            title: const Text('專家年齡'),
            subtitle: const Text('年滿 65 自動開啟長者模式'),
            trailing: SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: (ref.watch(expertAgeProvider) ?? '').toString(),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  suffixText: '歲',
                ),
                onChanged: (v) {
                  final n = int.tryParse(v.trim());
                  ref.read(expertAgeProvider.notifier).state = n;
                },
              ),
            ),
          ),
          if (elder) ...[
            ListTile(
              leading: const Icon(Icons.format_size),
              title: Text(l10n.elderScaleLabel),
              trailing: Text('${scale.toStringAsFixed(2)}×'),
              subtitle: Slider(
                value: scale,
                min: 1,
                max: 2,
                divisions: 8,
                label: scale.toStringAsFixed(2),
                onChanged: (v) {
                  ref.read(elderScaleProvider.notifier).state = v;
                },
              ),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.contrast),
              title: Text(l10n.elderContrastLabel),
              value: contrast,
              onChanged: (v) {
                ref.read(elderContrastProvider.notifier).state = v;
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.navigation_outlined),
              title: Text(l10n.elderSimplifyLabel),
              value: simplify,
              onChanged: (v) {
                ref.read(elderSimplifyProvider.notifier).state = v;
              },
            ),
          ],
          const Divider(height: 32),

          // ── 安全鎖（#13）：前台切回 / 超時重驗 ──
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(l10n.lockTitle),
            subtitle: Text(l10n.lockSubtitle),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.verified_user_outlined),
            title: Text(l10n.lockEnableLabel),
            value: lockEnabled,
            onChanged: (v) {
              ref.read(lockEnabledProvider.notifier).state = v;
            },
          ),
          if (lockEnabled) ...[
            ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: Text(l10n.lockTimeoutLabel),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SegmentedButton<Duration>(
                segments: [
                  ButtonSegment(
                    value: const Duration(minutes: 1),
                    label: Text(l10n.lockTimeoutMin1),
                  ),
                  ButtonSegment(
                    value: const Duration(minutes: 3),
                    label: Text(l10n.lockTimeoutMin3),
                  ),
                  ButtonSegment(
                    value: const Duration(minutes: 5),
                    label: Text(l10n.lockTimeoutMin5),
                  ),
                  ButtonSegment(
                    value: const Duration(minutes: 10),
                    label: Text(l10n.lockTimeoutMin10),
                  ),
                ],
                selected: {lockTimeout},
                onSelectionChanged: (selection) {
                  ref.read(lockTimeoutProvider.notifier).state =
                      selection.first;
                },
              ),
            ),
          ],
          const Divider(height: 32),
        ],
      ),
    );
  }
}
