import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/constant/AppColors.dart';

// Custom TextField Widget
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType inputType;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final RxBool?
      isPasswordHidden; // Optional RxBool for password visibility toggle
  final VoidCallback? togglePasswordVisibility;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.inputType,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.isPasswordHidden,
    this.togglePasswordVisibility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        child: TextField(
          controller: controller,
          keyboardType: inputType,
          obscureText: isPassword && isPasswordHidden?.value == true,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordHidden?.value == true
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: togglePasswordVisibility,
                  )
                : suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.focusColor, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }
}
