import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../ui/bottomNavigationBar.dart';

class LoginController extends GetxController {
  // Text controllers for email and password
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // Firebase Auth instance
  FirebaseAuth auth = FirebaseAuth.instance;

  // Track the loading state
  RxBool isLoading = false.obs;

  // Login function
  Future<void> login() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true; // Start loading
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.snackbar("Login Success", "Welcome back!");
      Get.offAll(BottomNavigationScreen()); // Navigate to home screen
    } on SocketException {
      // Handle no internet connection error
      Get.snackbar("Connection Error",
          "No internet connection. Please check your network.");
    } on FirebaseAuthException catch (e) {
      print(e.code);
      String errorMessage;
      switch (e.code) {
        case 'invalid-credential':
          errorMessage = "The email & password is not valid.";
          break;
        case 'channel-error':
          errorMessage = "can not empty ";
          break;
        case 'network-request-failed':
          errorMessage = "pleas on Network";
          // Get.to(internetExceptionScreen());
          break;
        default:
          errorMessage = "An unexpected error occurred. Please try again.";
      }
      Get.snackbar("Login Failed", errorMessage);
    } catch (e) {
      // Handle other errors
      Get.snackbar("Error", "Something went wrong. Please try again.");
    } finally {
      isLoading.value = false; // Reset loading state
    }
  }

// @override
// void onClose() {
//
//   emailController.dispose();
//   passwordController.dispose();
//   super.onClose();
// }
}
