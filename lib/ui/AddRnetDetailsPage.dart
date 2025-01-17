import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/Models/UserDataModel.dart';

import '../constant/AppColors.dart';
import '../constant/customTextFormFeild.dart';
import '../constant/customeButton.dart';
import '../controller/UserController.dart';

class Addrnetdetailspages extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  Addrnetdetailspages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Rent Details ... !",
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CustomInputField(
                controller: userController.nameController,
                hintText: 'Enter Name',
              ),
              CustomInputField(
                controller: userController.addressController,
                hintText: 'Enter Address',
                inputType: TextInputType.multiline,
                maxLines: 4,
              ),
              CustomInputField(
                controller: userController.numberController,
                hintText: 'Enter phoneNo.',
                inputType: TextInputType.phone,
              ),
              CustomInputField(
                controller: userController.amountController,
                hintText: 'Enter Rent Price .',
                inputType: TextInputType.number,
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomButton(
                text: 'Add Details ',
                onTap: () {
                  Get.back();
                  UserDataModels userData = UserDataModels(
                      name: userController.nameController.text.trim(),
                      address: userController.addressController.text.trim(),
                      number: userController.numberController.text.trim(),
                      email: FirebaseAuth.instance.currentUser?.email,
                      amount: int.tryParse(
                              userController.amountController.value.text) ??
                          0,
                      totalAmount: 0);

                  userController.addUserData(userData);
                  userController.addUserDataAllUser(userData);
                  userController.nameController.clear();
                  userController.amountController.clear();
                  userController.addressController.clear();
                  userController.numberController.clear();
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
