import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

class CustomSafeArea extends StatelessWidget {
  const CustomSafeArea({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.kPrimary,
      child: SafeArea(
        bottom: false,
        child: child,
      ),
    );
  }
}
