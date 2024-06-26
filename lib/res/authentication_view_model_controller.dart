import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationViewModel extends GetxController {
  final nameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final newPasswordController = TextEditingController().obs;
  final confirmPasswordController = TextEditingController().obs;

  void clearController() {
    nameController.value.clear();
    emailController.value.clear();
    passwordController.value.clear();
    newPasswordController.value.clear();
    confirmPasswordController.value.clear();
  }

  @override
  void onClose() {
    // Dispose of the controllers when the view model is closed
    nameController.value.dispose();
    emailController.value.dispose();
    passwordController.value.dispose();
    newPasswordController.value.dispose();
    confirmPasswordController.value.dispose();
    super.onClose();
  }
}
