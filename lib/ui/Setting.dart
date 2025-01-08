import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/constant/AppColors.dart';
import 'package:getx/constant/customeButton.dart';
import 'package:getx/ui/LoginScreen.dart';

import '../controller/dailogController.dart';

class Setting extends StatelessWidget {
  final dialogController = Get.put(DialogController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
                text: "logout ",
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Get.to(LoginScreen());
                }),
            Text(
              'Welcome to the Setting Page!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: Text("Enter Details"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name Field
                  TextField(
                    controller: dialogController.nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Amount Field
                  TextField(
                    controller: dialogController.amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back(); // Close the dialog
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Access and print the values
                    String name = dialogController.nameController.text;
                    String amount = dialogController.amountController.text;

                    // dialogController.nameController.clear();
                    // dialogController.amountController.clear();
                    Get.back(); // Close the dialog
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
            barrierDismissible: false, // Prevent closing by tapping outside
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
