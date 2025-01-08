import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../constant/AppColors.dart';
import '../constant/customTextFormFeild.dart';
import '../constant/customeButton.dart';
import '../constant/passwordFeild.dart';
import '../controller/signUpController.dart';
import '../controller/togglController.dart';
import '../responsive/Responsive.dart';
import 'LoginScreen.dart';

class SignUpScreen extends StatelessWidget {
  final SignUpController signupController = Get.put(SignUpController());
  final PasswordController passwordController = Get.put(PasswordController());

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Responsive(
          leptop: buildLaptopView(context, screenWidth, screenHeight),
          tablet: buildTabletView(context, screenWidth, screenHeight),
          phone: buildPhoneView(context, screenWidth, screenHeight),
        ),
      ),
    );
  }

  Widget buildLaptopView(
      BuildContext context, double screenWidth, double screenHeight) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: AppColors.primaryColor,
            height: screenHeight,
            child: Center(
              child: SvgPicture.asset(
                "assets/images/welcome.svg",
                height: screenHeight * 0.4,
              ),
            ),
          ),
        ),
        SizedBox(width: 30),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: buildForm(context, screenWidth, screenHeight),
        )),
      ],
    );
  }

  Widget buildTabletView(
      BuildContext context, double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: buildForm(context, screenWidth, screenHeight),
    );
  }

  Widget buildPhoneView(
      BuildContext context, double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: buildForm(context, screenWidth, screenHeight),
    );
  }

  Widget buildForm(
      BuildContext context, double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        SvgPicture.asset(
          "assets/images/welcome.svg",
          height: screenHeight * 0.3,
        ),
        SizedBox(height: 20),
        Text(
          "Welcome!",
          style: TextStyle(
            fontSize: Responsive.isPhone(context) ? screenWidth * 0.08 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        CustomInputField(
          controller: signupController.nameController,
          hintText: 'Enter Name',
        ),
        CustomInputField(
          controller: signupController.emailController,
          hintText: 'Enter Email',
          inputType: TextInputType.emailAddress,
        ),
        CustomInputField(
          controller: signupController.phoneNumberController,
          hintText: 'Enter phoneNo.',
          inputType: TextInputType.phone,
        ),
        CustomTextField(
          controller: signupController.passwordController,
          inputType: TextInputType.text,
          hintText: "Password",
          prefixIcon: Icon(Icons.lock),
          isPassword: true,
          isPasswordHidden: passwordController.isPasswordHidden,
          togglePasswordVisibility: passwordController.togglePasswordVisibility,
        ),
        SizedBox(height: screenHeight * 0.02),
        CustomButton(
          text: 'Sign Up',
          onTap: () {
            if (!signupController.isLoading.value) {
              signupController.signUp();
            }
          },
        ),
        SizedBox(height: screenHeight * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("I have already an account?"),
            TextButton(
              onPressed: () {
                Get.to(LoginScreen());
              },
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
