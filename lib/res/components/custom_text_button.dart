import 'package:flutter/material.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    Key? key,
    required this.text,
    this.fontSize = 14,
    required this.onPressed,
    this.color = AppColors.kPrimary,
  }) : super(key: key);

  final String text;
  final double? fontSize;
  final void Function()? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          width: 90,
          decoration: BoxDecoration(
              color: AppColors.kWhite, borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: color,
                  fontFamily: AppFonts.poppinsMedium,
                ),
              ),
            ),
          )),
    );
  }
}
