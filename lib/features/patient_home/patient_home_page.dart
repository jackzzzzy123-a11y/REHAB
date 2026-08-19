// lib/features/patient_home/patient_home_page.dart
//
// 患者 / 家屬 首頁：檢視本人康復進度與有限資訊（只讀）。
// 合規：患者僅能檢視本人資料（RBAC）；定位為輔助工具，不替代診症。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rehab_med/l10n/generated/app_localizations.dart';

import '../auth/providers/auth_provider.dart';

class PatientHomePage extends ConsumerWidget {
  const PatientHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(authNotifierProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.patientHomeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settings,
            onPressed: () => context.go('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            user?.displayName ?? '',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.show_chart),
              title: Text(l10n.myStage),
              subtitle: const Text('術後早期'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.event),
              title: Text(l10n.nextAppointment),
              subtitle: const Text('2026-08-20 10:00'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.insights),
              title: Text(l10n.myProgress),
              subtitle: Text(l10n.detailPlaceholder),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.chat_outlined),
            label: Text(l10n.contactDoctor),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.folder_open_outlined),
            label: Text(l10n.viewRecords),
          ),
        ],
      ),
    );
  }
}
