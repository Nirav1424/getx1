import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../Route/routes.dart';
import '../constant/AppColors.dart';
import '../constant/customTextFormFeild.dart';
import '../constant/customeButton.dart';
import '../constant/passwordFeild.dart';
import '../controller/loginController.dart';
import '../controller/togglController.dart';
import '../responsive/Responsive.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final PasswordController passwordController = Get.put(PasswordController());

  LoginScreen({Key? key}) : super(key: key);

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
          "Welcome Back !!",
          style: TextStyle(
            fontSize: Responsive.isPhone(context) ? screenWidth * 0.08 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        CustomInputField(
          controller: loginController.emailController,
          hintText: 'Enter Email',
          inputType: TextInputType.emailAddress,
        ),
        CustomTextField(
          controller: loginController.passwordController,
          inputType: TextInputType.text,
          hintText: "Password",
          prefixIcon: Icon(Icons.lock),
          isPassword: true,
          isPasswordHidden: passwordController.isPasswordHidden,
          togglePasswordVisibility: passwordController.togglePasswordVisibility,
        ),
        SizedBox(height: screenHeight * 0.02),
        CustomButton(
          text: 'Login',
          onTap: () {
            if (!loginController.isLoading.value) {
              loginController.login();
            }
          },
        ),
        SizedBox(height: screenHeight * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("I have No account?"),
            TextButton(
              onPressed: () {
                Get.offNamed(RoutesClass.getSignup());
              },
              child: Text(
                "Sign Up",
                style: TextStyle(
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
