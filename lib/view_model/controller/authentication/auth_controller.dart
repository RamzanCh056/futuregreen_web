import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_green_world/res/components/loading.dart';
import 'package:future_green_world/view/bottomNavBar/login_nav.dart';
import 'package:future_green_world/view/home/select_topic.dart';
import 'package:get/get.dart';

import '../../../models/user.dart';
import '../../../res/components/custom_snackbar.dart';
import '../../../res/controller/controller_instances.dart';
import '../../../view/bottomNavBar/bottom_nav_bar_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;

  var isLoggedIn = false.obs;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());

    ever(firebaseUser, _setInitialScreen);
  }

  String getCurrentUser() {
    final User user = auth.currentUser!;
    final uid = user.uid;

    return uid;
  }

  String getUserEmail() {
    final User user = auth.currentUser!;
    final email = user.email ?? "";
    return email;
  }

  _setInitialScreen(User? user) {
    if (user != null) {
      // user is logged in
      isLoggedIn.value = true;
      Get.offAll(() => const BottomNavigationBarScreen(),
          transition: Transition.fade);
    } else {
      // user is not logged in
      isLoggedIn.value = false;
      Get.offAll(() => const LoginNavScreen(), transition: Transition.fade);
    }
  }

  Future register(UserModel user, String password, BuildContext context) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: user.email, password: password)
          .then((value) => db.addUser(user, context));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          return "Email already used. Go to login page.";

        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          return "Wrong email/password combination.";

        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          return "No user found with this email.";

        case "ERROR_USER_DISABLED":
        case "user-disabled":
          return "User disabled.";

        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          return "Too many requests to log into this account.";

        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          return "Email address is invalid.";

        default:
          return "Login failed. Please try again.";
      }
    }
    return null;
  }

  Future login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          return "Email already used. Go to login page.";

        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          return "Wrong email/password combination.";

        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          return "No user found with this email.";

        case "ERROR_USER_DISABLED":
        case "user-disabled":
          return "User disabled.";

        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          return "Too many requests to log into this account.";

        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          return "Email address is invalid.";

        default:
          return "Login failed. Please try again.";
      }
    }
    return null;
  }

  // Delete Account
  Future deleteUserAccount(String password) async {
    try {
      AuthCredential credentials = EmailAuthProvider.credential(
          email: getUserEmail(), password: password);
      await auth.currentUser!
          .reauthenticateWithCredential(credentials)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(getCurrentUser())
            .delete()
            .then((value) {
          Get.offAll(() => const LoginNavScreen());
          auth.currentUser!.delete();
        });
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          return "Password is not correct";

        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
        case "user-mismatch":
          return "No user found with this email.";

        case "ERROR_USER_DISABLED":
        case "user-disabled":
          return "User disabled.";

        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          return "Too many requests to log into this account.";

        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          return "Email address is invalid.";

        default:
          return "Something went wrong. Please try again.";
      }
    }
    return null;
  }

  Future<void> sendPasswordResetEmail(String email, context) async {
    loadingDialog("Authenticating...");
    try {
      await auth.sendPasswordResetEmail(email: email).then((value) => {
            Get.close(2),
            showMessageSnackbar(
              "A link to reset password is sent to your email.",
              context,
            )
          });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          Get.close(2);
          showErrorSnackbar(
            "Entered email is invalid!",
            context,
          );
          break;

        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
        case "user-mismatch":
          Get.close(1);
          showErrorSnackbar(
            "No user found with this email",
            context,
          );
          break;

        default:
          Get.close(1);
          showErrorSnackbar(
            "Entered email is invalid!",
            context,
          );
          break;
      }
    }
  }

  void signOut() {
    try {
      Get.offAll(() => const LoginNavScreen());
      auth.signOut();
    } catch (e) {
      log(e.toString());
    }
  }
}
