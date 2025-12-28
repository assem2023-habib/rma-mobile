import 'package:flutter/material.dart';

class AppColors {
  // =========================
  // Primary Greens
  // =========================
  static const Color primary = Color(
    0xFF2E7D32,
  ); // اللون الأساسي (أزرار – AppBar)
  static const Color primaryDark = Color(
    0xFF1B5E20,
  ); // أخضر داكن (Hover / Headers)
  static const Color primaryLight = Color(
    0xFF66BB6A,
  ); // أخضر فاتح (Icons / Highlights)
  static const Color primarySoft = Color(
    0xFFA5D6A7,
  ); // أخضر ناعم (Buttons ثانوية)

  // =========================
  // Backgrounds
  // =========================
  static const Color backgroundMain = Color(
    0xFFF1F8F4,
  ); // خلفية التطبيق الرئيسية
  static const Color backgroundSecondary = Color(0xFFE8F5E9); // خلفية الأقسام
  static const Color backgroundCard = Color(0xFFFFFFFF); // خلفية الكروت

  // =========================
  // Text Colors
  // =========================
  static const Color textPrimary = Color(0xFF1B1B1B); // نص أساسي (عناوين)
  static const Color textSecondary = Color(0xFF4F4F4F); // نص ثانوي
  static const Color textMuted = Color(0xFF7A7A7A); // نص خافت
  static const Color textOnPrimary = Color(0xFFFFFFFF); // نص فوق الأخضر

  // =========================
  // Borders & Dividers
  // =========================
  static const Color border = Color(0xFFC8E6C9); // حدود الكروت
  static const Color divider = Color(0xFFBDBDBD); // خطوط فاصلة

  // =========================
  // Status Colors
  // =========================
  static const Color success = Color(0xFF2E7D32);
  static const Color info = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF9A825);
  static const Color error = Color(0xFFD32F2F);

  // =========================
  // Status Backgrounds
  // =========================
  static const Color successBg = Color(0xFFE8F5E9);
  static const Color warningBg = Color(0xFFFFFDE7);
  static const Color errorBg = Color(0xFFFDECEA);

  // Legacy Colors (Mapped to new ones to avoid breaking other screens)
  // =========================
  static const Color successLight = successBg;
  static const Color errorLight = errorBg;
  static const Color successDark = success;
  static const Color primaryBlue = primary;
  static const Color primaryIndigo = primaryDark;
  static const Color surface = backgroundCard;
  static const Color slate50 = backgroundMain;
  static const Color slate100 = backgroundSecondary;
  static const Color slate200 = border;
  static const Color slate300 = divider;
  static const Color slate400 = textMuted;
  static const Color slate500 = textSecondary;
  static const Color slate600 = textSecondary;
  static const Color slate700 = textPrimary;
  static const Color slate800 = textPrimary;
  static const Color slate900 = textPrimary;
  static const Color emerald500 = success;
  static const Color emerald600 = success;
  static const Color teal600 = info;
  static const Color teal700 = info;
  static const Color purple500 = primary;
  static const Color purple600 = primaryDark;
  static const Color pink600 = error;
  static const Color pink700 = errorDark;
  static const Color errorDark = Color(0xFFB91C1C);
}
