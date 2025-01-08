import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/loginController.dart';
import '../controller/signUpController.dart';
import 'AppColors.dart';

// CustomButton class
class CustomButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final double fontSize;
  final double padding;
  final double height;
  final bool isLoading;
  final Color color;

  // Constructor with required properties
  CustomButton({
    this.color = AppColors.primaryColor,
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.fontSize = 16.0,
    this.padding = 16.0,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    final SignUpController signupcontroller = Get.put(SignUpController());
    final LoginController loginController = Get.put(LoginController());

    return Obx(() => InkWell(
          onTap: () => onTap(), // Call the passed function on tap
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: height,
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  // Only horizontal padding
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    // Ensures the text scales to fit inside the container
                    child: (signupcontroller.isLoading.value ||
                            loginController.isLoading.value)
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize, // Use the provided font size
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1, // Prevents multiline text
                            overflow: TextOverflow
                                .ellipsis, // Adds "..." if the text overflows
                          ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
