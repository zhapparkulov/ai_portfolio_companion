import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const String fontFamily = 'Inter';

  static const display = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.05,
  );

  static const heading = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.15,
  );

  static const title = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const body = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.45,
  );

  static const bodySmall = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.35,
  );

  static const caption = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textMuted,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
  );

  static const button = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textInverted,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
}
