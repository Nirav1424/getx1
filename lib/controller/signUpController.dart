import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx/Models/UserModel.dart';
import 'package:getx/repository/UserRepository.dart';

import '../Route/routes.dart';

class SignUpController extends GetxController {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneNumberController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  final userRepo = Get.put(UserRepository());

  Future<void> signUp() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = FirebaseAuth.instance.currentUser!.uid;

      UserModel newUser = UserModel(
        id: uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        mobileNo: phoneNumberController.text.trim(),
        password: passwordController.text.trim(),
      );

      await userRepo.createUser(newUser);

      Get.offAllNamed(RoutesClass.getBotomNav());

      Get.snackbar("Success", "User registered successfully!");
    } on SocketException {
      Get.snackbar("Connection Error",
          "No internet connection. Please check your network.");
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "The email is already in use by another account.";
          break;
        case 'invalid-email':
          errorMessage = "The email address is not valid.";
          break;
        case 'weak-password':
          errorMessage = "The password is too weak.";
          break;
        case 'network-request-failed':
          errorMessage = "Please check your internet connection.";
          break;
        default:
          errorMessage = "An unexpected error occurred. Please try again.";
      }
      Get.snackbar("Sign Up Failed", errorMessage);
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }
}
