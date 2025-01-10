import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/constant/AppColors.dart';
import 'package:getx/constant/customTextFormFeild.dart';
import 'package:getx/constant/customeButton.dart';
import 'package:getx/ui/DonePage.dart';

import '../Models/UserDataModel.dart';
import '../controller/UserController.dart';

class AmountInputScreen extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments == null) {
      // Handle null arguments gracefully
      return Scaffold(
        body: Center(
          child: Text("No data provided!"),
        ),
      );
    }
    final String email = arguments['email'] ?? 'Unknown Email';
    final String name = arguments['name'] ?? 'Unknown Name';
    final String colorCode = arguments['color'] ?? 'grey';

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background for a fresh look
      appBar: AppBar(
        backgroundColor: colorCode == AppColors.REDTEXT
            ? AppColors.colorFailed
            : AppColors.colorSuccess,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          colorCode == 'red'
              ? "You gave ₹ to ${name}"
              : "You got ₹ from ${name}",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Larger padding for clean spacing
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Text
            Text(
              'Enter the amount',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),

            // Custom Input Field
            CustomInputField(
              controller: userController.amountController,
              inputType: TextInputType.number,
              hintText: "₹ Enter Amount",
            ),
            SizedBox(height: 30),

            // Reactive Save Button
            Obx(
              () => CustomButton(
                  color: userController.isButtonEnabled.value
                      ? colorCode == AppColors.REDTEXT
                          ? AppColors.colorFailed
                          : AppColors.colorSuccess
                      : Colors.grey.withOpacity(0.4),
                  text: "Save Details",
                  onTap: userController.isButtonEnabled.value
                      ? () {
                          colorCode == AppColors.REDTEXT
                              ? userController.updateColor(AppColors.RED)
                              : userController.updateColor(AppColors.GREEN);
                          UserDataModels userData = UserDataModels(
                            amount: int.tryParse(userController
                                    .amountController.value.text) ??
                                0,
                            color: userController.selectedColor.value,
                            totalAmount: userController.totalBalance.value
                                .toDouble()
                                .toInt(),
                            name: email.trim(),
                          );
                          userController.addUserData(userData);
                          userController.nameController.clear();
                          userController.amountController.clear();
                          Get.off(
                            () => DonePage(),
                            arguments: {
                              'email': email,
                              'name': name,
                              'color': colorCode,
                              'amount': '22',
                            },
                          );
                        }
                      : () {}
                  // Rounded corners for button
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
