// lib/app/router/app_router.dart
//
// 宣告式路由（go_router）。含 auth / 角色守衛（RBAC）：
// - 未登入 → /login
// - 已登入卻停留在登入頁 → 導向角色首頁
// - 越權路由（醫生訪問 /patient 或反之）→ 彈回自身角色首頁
// 合規：路由層即做存取控制；不於 URI query 傳遞任何病人敏感資料。

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_page.dart';
import '../../features/auth/domain/user_role.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/communication/communication_page.dart';
import '../../features/import/import_page.dart';
import '../../features/patient_dashboard/dashboard_page.dart';
import '../../features/patient_dashboard/patient_detail_page.dart';
import '../../features/patient_home/patient_home_page.dart';
import '../../features/patient_upload/patient_upload_page.dart';
import '../../features/settings/settings_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final auth = ref.read(authNotifierProvider);
      final loggedIn = auth.isLoggedIn;
      final role = auth.user?.role;
      final loc = state.matchedLocation;

      // 未登入
      if (!loggedIn) {
        return loc == '/login' ? null : '/login';
      }
      // 已登入卻停留在登入頁 → 導向角色首頁
      if (loc == '/login') {
        return role!.homeRoute;
      }
      // RBAC：依角色守衛（設定頁 /settings 對兩角色開放）
      if (loc == '/settings') {
        return null;
      }
      if (role == UserRole.doctor && !loc.startsWith('/doctor')) {
        return '/doctor';
      }
      if (role == UserRole.patient && !loc.startsWith('/patient')) {
        return '/patient';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const AuthPage(),
      ),
      // 設定（#9 主題 / #10 字體 / #13 安全鎖）：兩角色共用
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      // 醫生：患者總覽
      GoRoute(
        path: '/doctor',
        builder: (context, state) => const DashboardPage(),
      ),
      // 醫生：匯入康復資料（P1-3）
      GoRoute(
        path: '/doctor/import',
        builder: (context, state) => const ImportPage(),
      ),
      GoRoute(
        path: '/doctor/patient/:patientId',
        builder: (context, state) => PatientDetailPage(
          patientId: state.pathParameters['patientId'] ?? '',
        ),
      ),
      // 患者 / 家屬：本人康復總覽
      GoRoute(
        path: '/patient',
        builder: (context, state) => const PatientHomePage(),
      ),
      // 醫患溝通（P2-c）：醫生 / 患者雙入口，頁內依角色區分「我 / 對方」。
      GoRoute(
        path: '/doctor/communication',
        builder: (context, state) => const CommunicationPage(),
      ),
      GoRoute(
        path: '/patient/communication',
        builder: (context, state) => const CommunicationPage(),
      ),
      // 患者端上傳（P2-d）：PII 同意 + 媒體選取 + 模糊標記存庫。
      GoRoute(
        path: '/patient/upload',
        builder: (context, state) => const PatientUploadPage(),
      ),
    ],
  );
});
