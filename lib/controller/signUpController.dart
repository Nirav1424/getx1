import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx/Models/UserModel.dart';
import 'package:getx/repository/UserRepository.dart';
import 'package:getx/ui/bottomNavigationBar.dart';

class SignUpController extends GetxController {
  // Text controllers for form fields
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneNumberController = TextEditingController();

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  // User repository instance for Firestore operations
  final userRepo = Get.put(UserRepository());

  // Sign-up function
  Future<void> signUp() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true; // Start loading

      // Create a new user in Firebase Authentication
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Get the UID of the newly created user
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Create a new user model
      UserModel newUser = UserModel(
        id: uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        mobileNo: phoneNumberController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Store user details in Firestore
      await userRepo.createUser(newUser);

      // Navigate to the home screen
      Get.offAll(BottomNavigationScreen());
      Get.snackbar("Success", "User registered successfully!");
    } on SocketException {
      // Handle no internet connection error
      Get.snackbar("Connection Error",
          "No internet connection. Please check your network.");
    } on FirebaseAuthException catch (e) {
      print(e.code);
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
          // Get.to(internetExceptionScreen());
          break;
        default:
          errorMessage = "An unexpected error occurred. Please try again.";
      }
      Get.snackbar("Sign Up Failed", errorMessage);
    } catch (e) {
      // Handle other errors
      Get.snackbar("Error", "Something went wrong. Please try again.");
    } finally {
      isLoading.value = false; // Reset loading state
    }
  }
}
