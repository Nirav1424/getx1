import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/constant/AppColors.dart';
import 'package:getx/constant/customeButton.dart';

import '../Models/UserDataModel.dart';
import '../controller/UserController.dart';
import '../repository/UserRepository.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  final UserController userController = Get.put(UserController());
  final userRepo = Get.put(UserRepository());

  @override
  Widget build(BuildContext context) {
    String email = Get.arguments; // Retrieving the name passed via GetX
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text(email,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.call),
            ),
          ],
        ),
        body: Padding(
          padding:
              const EdgeInsets.all(16.0), // Adds padding around the content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StreamBuilder<List<UserDataModels>>(
                  stream: userRepo
                      .getUserDataDetails(), // Stream<List<UserDataModels>>
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('No data available');
                    } else {
                      final userDataList = snapshot.data!;
                      return ListView.builder(
                        itemCount: userDataList.length,
                        itemBuilder: (context, index) {
                          final userData = userDataList[index];
                          if (email
                              .toString()
                              .contains(userData.name.toString())) {
                            return Card(
                              child: ListTile(
                                title: Text(userData.name),
                                subtitle: Text(
                                  'Amount: \$${userData.amount}',
                                  style: TextStyle(
                                    color: Color(int.parse(
                                            userData.color!.substring(1, 7),
                                            radix: 16) +
                                        0xFF000000),
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    // Ensure the id is not null
                                    if (userData.id != null) {
                                      // Call deleteUserData with non-null id
                                      userController
                                          .removeUserData(userData.id!);
                                    } else {
                                      Get.snackbar(
                                          "Error", "User data ID is null.");
                                    }
                                  },
                                ),
                              ),
                            );
                          } else {
                            return SizedBox
                                .shrink(); // Return an empty widget if not matching
                          }
                        },
                      );
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Aligns the buttons in the row
                children: [
                  Expanded(
                    child: CustomButton(
                      color: Colors.red,
                      text: "You Gave",
                      onTap: () {
                        userController.updateColor(Colors.red);
                        Get.dialog(
                          AlertDialog(
                            title: Text("Enter Details"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Name Field
                                // TextField(
                                //   controller: userController.nameController,
                                //   decoration: InputDecoration(
                                //     labelText: 'Name',
                                //     border: OutlineInputBorder(),
                                //   ),
                                // ),
                                SizedBox(height: 16),
                                // Amount Field
                                TextField(
                                  controller: userController.amountController,
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
                                  UserDataModels userData = UserDataModels(
                                    amount: int.tryParse(userController
                                            .amountController.value.text) ??
                                        0,
                                    color: userController.selectedColor.value,
                                    name: email.trim(),
                                  );
                                  userController.addUserData(userData);
                                  userController.nameController.clear();
                                  userController.amountController.clear();
                                  Get.back(); // Close the dialog
                                },
                                child: Text('Submit'),
                              ),
                            ],
                          ),
                          barrierDismissible:
                              false, // Prevent closing by tapping outside
                        );
                      },
                      height: 50, // You can set a fixed height for consistency
                    ),
                  ),
                  SizedBox(width: 20), // Adds spacing between buttons
                  Expanded(
                    child: CustomButton(
                      text: "You Got",
                      onTap: () {
                        userController.updateColor(AppColors.primaryColor);
                        Get.dialog(
                          AlertDialog(
                            title: Text("Enter Details"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Name Field
                                // TextField(
                                //   controller: userController.nameController,
                                //   decoration: InputDecoration(
                                //     labelText: 'Name',
                                //     border: OutlineInputBorder(),
                                //   ),
                                // ),
                                SizedBox(height: 16),
                                // Amount Field
                                TextField(
                                  controller: userController.amountController,
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
                                  UserDataModels userData = UserDataModels(
                                    amount: int.tryParse(userController
                                            .amountController.value.text) ??
                                        0,
                                    color: userController.selectedColor.value,
                                    name: email.trim(),
                                  );
                                  userController.addUserData(userData);
                                  userController.nameController.clear();
                                  userController.amountController.clear();
                                  Get.back(); // Close the dialog
                                },
                                child: Text('Submit'),
                              ),
                            ],
                          ),
                          barrierDismissible:
                              false, // Prevent closing by tapping outside
                        );
                      },
                      height: 50, // Same height as the other button
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
