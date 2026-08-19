// lib/features/auth/auth_page.dart
//
// 登入頁（醫生 / 患者 雙角色）。
// 合規：登入後方可存取資料；須勾選個人資料收集聲明（PDPO 第1原則告知）。
// 無障礙：足夠觸控目標、語義標籤、錯誤以 live region 播報；字體遵循系統縮放。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rehab_med/core/config/constants.dart';
import 'package:rehab_med/core/security/biometric.dart';
import 'package:rehab_med/core/storage/secure_storage.dart';
import 'package:rehab_med/l10n/generated/app_localizations.dart';

import 'domain/user_role.dart';
import 'providers/auth_provider.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  UserRole _role = UserRole.doctor;
  bool _obscure = true;
  bool _consent = false;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  String _roleLabel(UserRole role, AppLocalizations l10n) => switch (role) {
        UserRole.doctor => l10n.roleDoctor,
        UserRole.patient => l10n.rolePatient,
      };

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    if (!_consent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.consentRequired)),
      );
      return;
    }
    ref.read(authNotifierProvider.notifier).login(
          role: _role,
          username: _usernameCtrl.text,
          password: _passwordCtrl.text,
        );
  }

  Future<void> _biometricLogin() async {
    final existing = await ref
        .read(secureStorageProvider)
        .readSecret(AppConstants.secureStorageTokenKey);
    if (existing == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('請先以帳號密碼登入，再啟用生物辨識'),
        ),
      );
      return;
    }
    final ok = await Biometric(LocalAuthentication()).authenticate();
    if (ok && mounted) {
      // 還原會話後由 ref.listen 導向角色首頁
      await ref.read(authNotifierProvider.notifier).restoreSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = ref.watch(authNotifierProvider);

    // 登入成功 → 依角色導向專屬首頁
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next.user != null && prev?.user == null && mounted) {
        context.go(next.user!.role.homeRoute);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 免責聲明
                    Semantics(
                      label: l10n.onlyForReference,
                      child: Chip(
                        avatar: const Icon(Icons.info_outline, size: 18),
                        label: Text(l10n.onlyForReference),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.appTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.selectRole,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // 角色選擇
                    SegmentedButton<UserRole>(
                      selected: {_role},
                      onSelectionChanged: (set) =>
                          setState(() => _role = set.first),
                      segments: UserRole.values
                          .map(
                            (r) => ButtonSegment<UserRole>(
                              value: r,
                              label: Text(_roleLabel(r, l10n)),
                              icon: Icon(r.icon),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    // 帳號
                    TextFormField(
                      controller: _usernameCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.username,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username],
                    ),
                    const SizedBox(height: 12),
                    // 密碼
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: l10n.password,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 8),
                    // 錯誤（無障礙 live region）
                    if (auth.error != null)
                      Semantics(
                        liveRegion: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            auth.error!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    // 同意聲明
                    CheckboxListTile(
                      value: _consent,
                      onChanged: (v) => setState(() => _consent = v ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        l10n.consentText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 登入按鈕
                    FilledButton(
                      onPressed: auth.isLoading ? null : _submit,
                      child: auth.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(l10n.login),
                    ),
                    const SizedBox(height: 12),
                    // 生物辨識
                    OutlinedButton.icon(
                      onPressed: auth.isLoading ? null : _biometricLogin,
                      icon: const Icon(Icons.fingerprint),
                      label: Text(l10n.biometricLogin),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
