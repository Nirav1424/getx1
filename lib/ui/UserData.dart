import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/UserDataModel.dart';
import '../constant/AppColors.dart';
import '../controller/UserController.dart';
import '../repository/UserRepository.dart';

class UserData extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final userRepo = Get.put(UserRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Image

            const SizedBox(height: 16),
            // Real-time List of Cards for userData
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
                        return Card(
                          child: ListTile(
                            title: Text(userData.name),
                            subtitle: Text('Amount: \$${userData.amount}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Ensure the id is not null
                                if (userData.id != null) {
                                  // Call deleteUserData with non-null id
                                  userController.removeUserData(userData.id!);
                                } else {
                                  Get.snackbar(
                                      "Error", "User data ID is null.");
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
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
                    controller: userController.nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
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
                      amount: int.tryParse(
                              userController.amountController.value.text) ??
                          0,
                      name: userController.nameController.text.trim(),
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
