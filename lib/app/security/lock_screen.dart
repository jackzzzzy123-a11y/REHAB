// lib/app/security/lock_screen.dart
//
// 鎖屏（#13）：覆蓋整個 App，驗證（生物辨識 / 密碼兜底）通過才解鎖。
// 合規：重驗不另設獨立鎖；PII 靜態加密已由儲存層保證（見 core/security/encryption.dart）。
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rehab_med/core/security/biometric.dart';
import 'package:rehab_med/l10n/generated/app_localizations.dart';

import 'lock_providers.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  bool _verifying = false;
  bool _biometricFailed = false;
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _verifyBiometric() async {
    setState(() {
      _verifying = true;
      _biometricFailed = false;
    });
    try {
      final ok = await Biometric(LocalAuthentication()).authenticate();
      if (ok && mounted) {
        ref.read(lockControllerProvider.notifier).unlock();
      } else if (mounted) {
        setState(() => _biometricFailed = true);
      }
    } catch (_) {
      // 平台不支援生物辨識等 → 顯示密碼兜底。
      if (mounted) setState(() => _biometricFailed = true);
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  void _verifyPassword() {
    // Demo 兜底：與 mock 登入一致，≥6 位即可（真實產品改接服務端驗證）。
    final text = _passwordController.text.trim();
    if (text.length >= 6) {
      ref.read(lockControllerProvider.notifier).unlock();
    } else if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.unlockPasswordHint)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 56),
                const SizedBox(height: 16),
                Text(
                  l10n.lockScreenTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(l10n.lockScreenHint, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _verifying ? null : _verifyBiometric,
                  icon: _verifying
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.fingerprint),
                  label: Text(l10n.unlockButton),
                ),
                if (_biometricFailed) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.unlockPasswordLabel,
                      helperText: l10n.unlockPasswordHint,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _verifyPassword(),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _verifyPassword,
                    child: Text(l10n.unlockButton),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
