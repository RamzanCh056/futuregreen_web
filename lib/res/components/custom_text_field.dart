import 'package:flutter/material.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/controllers/theme_controller.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.labelText,
      required this.keyboardType,
      required this.textInputAction,
      required this.validator,
      this.title,
      this.savedValue,
      this.readOnly,
      this.isPrefixIconEnabled = false,
      this.obscure = false,
      this.icon = Icons.abc,
      this.floatingLabelBehaviour = true})
      : super(key: key);
  final TextEditingController? controller;
  final bool? readOnly;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String?)? savedValue;
  final bool floatingLabelBehaviour;
  final String? title;
  final bool? obscure;

  final bool? isPrefixIconEnabled;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
        Get.find<ThemeController>(); // Reference to ThemeController

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Column(
              children: [
                Text(
                  title!,
                  style: TextStyle(
                      fontFamily: AppFonts.inter,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          TextFormField(
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            readOnly: readOnly ?? false,
            controller: controller,
            style: TextStyle(
                color: themeController.isDarkMode
                    ? DarkModeColors.kWhite
                    : AppColors.kPrimary),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10),
                hintText: hintText,
                hintStyle: GoogleFonts.playfairDisplay(
                  color: themeController.isDarkMode
                      ? AppColors.kLightGrey
                      : AppColors.kBlack.withOpacity(0.5),
                  fontSize: 14,
                  // fontFamily: AppFonts.poppinsRegular
                ),
                //Just for this app
                floatingLabelBehavior: floatingLabelBehaviour
                    ? FloatingLabelBehavior.always
                    : FloatingLabelBehavior.never,
                labelText: labelText,
                labelStyle: const TextStyle(
                    fontSize: 16,
                    color: AppColors.kLightGrey,
                    fontFamily: AppFonts.poppinsRegular),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        //Just for tis app
                        color: AppColors.kLightGrey,
                        width: 1.5)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    borderSide:
                        const BorderSide(color: AppColors.kGrey, width: 1.5)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: AppColors.kRed, width: 1.5)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: AppColors.kRed, width: 1.5)),
                prefixIcon: isPrefixIconEnabled!
                    ? Icon(
                        icon,
                        color: AppColors.kPrimary,
                      )
                    : null),
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            validator: validator,
            onSaved: savedValue,
          ),
        ],
      ),
    );
  }
}



// class CustomTextField extends StatelessWidget {
//   const CustomTextField({
//     Key? key,
//     required this.controller,
//     required this.hintText,
//     required this.labelText,
//     required this.keyboardType,
//     required this.textInputAction,
//     required this.validator,
//     this.savedValue,
//     this.readOnly,
//     this.isPrefixIconEnabled = false,
//     this.icon = Icons.abc,
//     this.floatingLabelBehaviour=true
//   }) : super(key: key);
//   final TextEditingController? controller;
//   final bool? readOnly;
//   final String? hintText;
//   final String? labelText;
//   final TextInputType? keyboardType;
//   final TextInputAction? textInputAction;
//   final String? Function(String?)? validator;
//   final void Function(String?)? savedValue;
//   final bool floatingLabelBehaviour;
//
//   final bool? isPrefixIconEnabled;
//   final IconData? icon;
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: TextFormField(
//         maxLines: null,
//         textCapitalization: TextCapitalization.sentences,
//         readOnly: readOnly ?? false,
//         controller: controller,
//         style: TextStyle(
//             color: themeController.isDarkMode
//                 ? DarkModeColors.kWhite
//                 : AppColors.kPrimary),
//         decoration: InputDecoration(
//             hintText: hintText,
//             hintStyle: TextStyle(
//                 color: themeController.isDarkMode
//                     ? AppColors.kGrey
//                     : AppColors.kBlack.withOpacity(0.5),
//                 fontSize: 16,
//                 fontFamily: AppFonts.poppinsRegular),
//             //Just for this app
//             floatingLabelBehavior: floatingLabelBehaviour?FloatingLabelBehavior.always:FloatingLabelBehavior.never,
//             labelText: labelText,
//             labelStyle: const TextStyle(
//                 fontSize: 16,
//                 color: AppColors.kPrimary,
//                 fontFamily: AppFonts.poppinsRegular),
//             border: InputBorder.none,
//             enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(
//                   //Just for tis app
//                     color: AppColors.kPrimary,
//                     width: 1.5)),
//             focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(
//                   10,
//                 ),
//                 borderSide:
//                 const BorderSide(color: AppColors.kPrimary, width: 1.5)),
//             errorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide:
//                 const BorderSide(color: AppColors.kRed, width: 1.5)),
//             focusedErrorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide:
//                 const BorderSide(color: AppColors.kRed, width: 1.5)),
//             prefixIcon: isPrefixIconEnabled!
//                 ? Icon(
//               icon,
//               color: AppColors.kPrimary,
//             )
//                 : null),
//         keyboardType: keyboardType,
//         textInputAction: textInputAction,
//         validator: validator,
//         onSaved: savedValue,
//       ),
//     );
//   }
// }
