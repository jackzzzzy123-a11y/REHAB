// lib/features/patient_dashboard/dashboard_page.dart
//
// 醫生首頁（P1-4 主從佈局）。左：綁定患者清單（搜尋 + 點選）；
// 右：數據驅動分析面板。大屏優先（Row 主從）；窄屏點選跳轉詳情路由。
// 合規：僅顯示當前醫生權限內患者（RBAC）；清單源自加密儲存。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rehab_med/l10n/generated/app_localizations.dart';

import '../../app/theme/theme_providers.dart';
import '../../data/models/patient_profile.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'analytics/patient_analytics_panel.dart';
import 'providers/dashboard_providers.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  String? _selectedId;

  Future<void> _logout() async {
    ref.read(selectedPatientAgeProvider.notifier).state = null;
    await ref.read(authNotifierProvider.notifier).logout();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final patientsAsync = ref.watch(patientsProvider);
    final demo = ref.watch(demoSeedNotifierProvider);
    // 長者模式：簡化導航時隱藏次要入口（匯入 / 載入範例）。
    final simplify = ref.watch(elderSimplifyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.patientDashboard),
        actions: [
          if (!simplify) ...[
            IconButton(
              icon: const Icon(Icons.upload_file),
              tooltip: l10n.importEntry,
              onPressed: () => context.go('/doctor/import'),
            ),
            IconButton(
              icon: demo.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.science_outlined),
              tooltip: l10n.loadDemo,
              onPressed: demo.isLoading
                  ? null
                  : () => ref.read(demoSeedNotifierProvider.notifier).load(),
            ),
          ],
          IconButton(
            icon: const Icon(Icons.chat_outlined),
            tooltip: l10n.contactDoctor,
            onPressed: () => context.go('/doctor/communication'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settings,
            onPressed: () => context.go('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: _logout,
          ),
        ],
      ),
      body: patientsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (patients) {
          if (patients.isEmpty) {
            return _EmptyState(l10n: l10n);
          }
          final current = (_selectedId != null
                  ? patients
                      .where((p) => p.patientId == _selectedId)
                      .firstOrNull
                  : null) ??
              patients.first;

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 720) {
                return Row(
                  children: [
                    SizedBox(
                      width: 320,
                      child: _PatientList(
                        patients: patients,
                        selectedId: current.patientId,
                        onTap: (id) => setState(() => _selectedId = id),
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: PatientAnalyticsPanel(
                        patientId: current.patientId,
                        displayName: current.displayName,
                        stage: current.rehabStage,
                      ),
                    ),
                  ],
                );
              }
              // 窄屏：清單，點選跳轉詳情路由（面板全屏）。
              return _PatientList(
                patients: patients,
                selectedId: current.patientId,
                onTap: (id) => context.go('/doctor/patient/$id'),
              );
            },
          );
        },
      ),
    );
  }
}

class _PatientList extends ConsumerWidget {
  const _PatientList({
    required this.patients,
    required this.selectedId,
    required this.onTap,
  });
  final List<PatientProfile> patients;
  final String selectedId;
  final void Function(String id) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final query = ref.watch(patientQueryProvider);
    final filtered = query.trim().isEmpty
        ? patients
        : patients.where((p) {
            final hay =
                '${p.displayName} ${p.rehabStage} ${p.patientId}'
                    .toLowerCase();
            return hay.contains(query.trim().toLowerCase());
          }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: (v) => ref
                .read(patientQueryProvider.notifier)
                .state = v,
            decoration: InputDecoration(
              hintText: l10n.searchPatients,
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? Center(child: Text(l10n.noPatients))
              : ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final p = filtered[i];
                    final selected = p.patientId == selectedId;
                    return ListTile(
                      selected: selected,
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(p.displayName),
                      subtitle: Text(
                        '${l10n.bedNo}：${p.patientId} · ${p.rehabStage}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // 患者端長者模式：選中即按出生年月算齡，滿 65 自動套用。
                        ref.read(selectedPatientAgeProvider.notifier).state =
                            ageFromDob(p.dateOfBirth);
                        onTap(p.patientId);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.people_outline, size: 56, color: Colors.grey),
            const SizedBox(height: 16),
            Text(l10n.noPatients,
                style: Theme.of(context).textTheme.titleMedium,),
            const SizedBox(height: 8),
            Text(l10n.seedOrImportHint,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => context.go('/doctor/import'),
              icon: const Icon(Icons.upload_file),
              label: Text(l10n.importEntry),
            ),
          ],
        ),
      ),
    );
  }
}
