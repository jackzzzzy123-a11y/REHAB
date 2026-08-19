// lib/features/auth/domain/user_role.dart
//
// 使用者角色（醫生 / 患者）。決定登入後導向的首頁與可取覽資料範圍（RBAC）。
// 合規：醫生僅能檢視權限內患者；患者僅能檢視本人資料。

import 'package:flutter/material.dart';

enum UserRole { doctor, patient }

extension UserRoleX on UserRole {
  // 登入後導向的角色專屬首頁路由。
  String get homeRoute {
    switch (this) {
      case UserRole.doctor:
        return '/doctor';
      case UserRole.patient:
        return '/patient';
    }
  }

  // 無障礙：提供圖示供螢幕閱讀器與視覺區分。
  IconData get icon {
    switch (this) {
      case UserRole.doctor:
        return Icons.medical_services_outlined;
      case UserRole.patient:
        return Icons.favorite_outlined;
    }
  }
}
