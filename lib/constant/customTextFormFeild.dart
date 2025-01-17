import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/togglController.dart';
import 'AppColors.dart';

// Custom Input Field Widget
class CustomInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType? inputType;
  final bool obscureText;
  final double fontSize;
  final double verticalPadding;
  final int? maxLength;
  final int? maxLines;

  // Constructor to initialize the controller and other properties
  CustomInputField({
    this.controller,
    required this.hintText,
    this.maxLength,
    this.maxLines,
    this.inputType, // Default type is text
    this.obscureText = false, // Default to not obscure text
    this.fontSize = 16.0,
    this.verticalPadding = 10.0,
  });

  final PasswordController passwordController = Get.put(PasswordController());

  @override
  Widget build(BuildContext context) {
    // Get screen height for responsive design
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: TextField(
        maxLength: maxLength,
        controller: controller,
        maxLines: maxLines,
        keyboardType: inputType,
        // Set the input type (email, phone, etc.)
        obscureText: obscureText,
        // This controls whether the text is obscured (used for password)
        decoration: InputDecoration(
          hintText: hintText,
          // suffix: _getSuffixIcon(),

          prefixIcon: _getPrefixIcon(),
          // Get the corresponding prefix icon based on the field
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green),
          ),
        ),
      ),
    );
  }

  // Method to return the appropriate prefix icon based on input field
  Widget? _getPrefixIcon() {
    if (hintText.toLowerCase().contains("email")) {
      return Icon(Icons.email);
    } else if (hintText.toLowerCase().contains("password")) {
      return Icon(Icons.lock);
    } else if (hintText.toLowerCase().contains("phone")) {
      return Icon(Icons.phone);
    } else if (hintText.toLowerCase().contains("name")) {
      return Icon(Icons.person);
    } else if (hintText.toLowerCase().contains("rent")) {
      return Icon(Icons.currency_rupee);
    } else if (hintText.toLowerCase().contains("address")) {
      return Icon(Icons.location_on);
    }
    return null;
  }

// Widget? _getSuffixIcon() {
//   if (hintText.toLowerCase().contains("password")) {
//     return IconButton(
//       icon: Icon(passwordController.isPasswordHidden.value
//           ? Icons.visibility
//           : Icons.visibility_off),
//       onPressed: () {
//         passwordController.togglePasswordVisibility();
//       },
//     );
//   }
//   return null;
// }
}
