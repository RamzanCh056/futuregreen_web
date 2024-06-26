import 'package:flutter/material.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class WebCustomElevatedButton extends StatelessWidget {
  const WebCustomElevatedButton(
      {super.key,
      this.height = 38,
      this.width = 60,
      this.buttonColor = AppColors.kPrimary,
      this.textColor = AppColors.kWhite,
      required this.title,
      this.loading = false,
      required this.onPress,
      this.borderRadius = 8});
  final bool? loading;
  final String? title;
  final double? height, width;
  final Color? textColor, buttonColor;
  final void Function()? onPress;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
        ),
        onPressed: onPress,
        child: loading!
            ? const CircularProgressIndicator(
                color: AppColors.kWhite,
              )
            : Text(
                title!,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kWhite
                )

                // TextStyle(
                //     color: textColor,
                //     fontSize: 20,
                //     fontFamily: AppFonts.playFair),
              ),
      ),
    );
  }
}
