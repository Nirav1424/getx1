import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Route/routes.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  Future<void> login() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.snackbar("Login Success", "Welcome back!");
      Get.offAllNamed(RoutesClass.getBotomNav());
    } on SocketException {
      Get.snackbar("Connection Error",
          "No internet connection. Please check your network.");
    } on FirebaseAuthException catch (e) {
      _handleFirebaseError(e);
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  void _handleFirebaseError(FirebaseAuthException e) {
    String errorMessage;

    switch (e.code) {
      case 'invalid-credential':
        errorMessage = "The email & password are not valid.";
        break;
      case 'channel-error':
        errorMessage = "Cannot be empty.";
        break;
      case 'network-request-failed':
        errorMessage = "Please check your network connection.";
        break;
      default:
        errorMessage = "An unexpected error occurred. Please try again.";
    }

    Get.snackbar("Login Failed", errorMessage);
  }
}
