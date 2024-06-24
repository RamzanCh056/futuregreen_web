import 'package:flutter/material.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';

import '../controller/controller_instances.dart';

class CustomPasswordTextField extends StatefulWidget {
  const CustomPasswordTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.keyboardType,
    required this.textInputAction,
    required this.validator,
    required this.savedValue,
    this.readOnly,
    this.isPrefixIconEnabled = false,
    this.icon = Icons.abc,
  }) : super(key: key);
  final TextEditingController? controller;
  final bool? readOnly;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String?)? savedValue;
  final bool? isPrefixIconEnabled;
  final IconData? icon;

  @override
  State<CustomPasswordTextField> createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  // Initially password is obscure
  bool _obscureText = false;
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        readOnly: widget.readOnly ?? false,
        controller: widget.controller,
        style: TextStyle(
            color: themeController.isDarkMode
                ? DarkModeColors.kWhite
                : AppColors.kPrimary),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
              color: themeController.isDarkMode
                  ? AppColors.kGrey
                  : AppColors.kBlack.withOpacity(0.5),
              fontSize: 16,
              fontFamily: AppFonts.poppinsRegular),
          //Just for this app
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: widget.labelText,
          labelStyle: const TextStyle(
              fontSize: 16,
              color: AppColors.kPrimary,
              fontFamily: AppFonts.poppinsRegular),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  //Just for tis app
                  color: AppColors.kPrimary,
                  width: 1.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                10,
              ),
              borderSide:
                  const BorderSide(color: AppColors.kPrimary, width: 1.5)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.kRed, width: 1.5)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.kRed, width: 1.5)),
          prefixIcon: widget.isPrefixIconEnabled!
              ? Icon(
                  widget.icon,
                  color: AppColors.kPrimary,
                )
              : null,

          suffixIcon: IconButton(
            //focusColor: Colors.red,
            onPressed: _toggle,
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: AppColors.kPrimary,
            ),
          ),
        ),
        obscureText: _obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        validator: widget.validator,
        onSaved: widget.savedValue,
      ),
    );
  }
}
