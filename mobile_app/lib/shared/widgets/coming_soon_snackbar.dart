import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../extensions/l10n_extensions.dart';

void showComingSoonSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(context.l10n.featureInDevelopment),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
      ),
    );
}
