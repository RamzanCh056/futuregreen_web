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
  }
}
