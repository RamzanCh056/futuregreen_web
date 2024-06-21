import 'package:flutter/material.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';

class CustomIconElevatedButton extends StatelessWidget {
  const CustomIconElevatedButton(
      {super.key,
      this.height = 60,
      this.width = 64,
      this.buttonColor = AppColors.kPrimary,
      this.textColor = AppColors.kWhite,
      required this.title,
      this.loading = false,
      required this.onPress,
      required this.icon,
      this.iconColor = AppColors.kWhite,
      this.borderRadius = 15});
  final bool? loading;
  final String? title;
  final double? height, width;
  final Color? textColor, buttonColor, iconColor;
  final void Function()? onPress;
  final IconData? icon;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
        ),
        onPressed: onPress,
        icon: Icon(
          icon,
          color: iconColor,
        ),
        label: loading!
            ? const CircularProgressIndicator(
                color: AppColors.kWhite,
              )
            : Text(
                title!,
                style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontFamily: AppFonts.poppinsRegular),
              ),
      ),
    );
  }
}
