import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../colors/app_colors.dart';

void showMessageSnackbar(
  String message,
  BuildContext context,
) {
  return showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        message: message,
        backgroundColor: AppColors.kGreen,
        messagePadding: const EdgeInsets.symmetric(horizontal: 18),
        icon: const Icon(Icons.sentiment_satisfied_alt,
            color: Color(0x15000000), size: 120),
      ),
      dismissDirection: [DismissDirection.up, DismissDirection.horizontal],
      dismissType: DismissType.onSwipe);
}

void showErrorSnackbar(
  String message,
  BuildContext context,
) {
  return showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: message,
        messagePadding: const EdgeInsets.symmetric(horizontal: 18),
      ),
      dismissDirection: [DismissDirection.up, DismissDirection.horizontal],
      dismissType: DismissType.onSwipe);
}
