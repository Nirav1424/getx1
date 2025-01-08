import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/constant/AppColors.dart';

import '../Models/UserModel.dart';
import '../controller/profileController.dart';

class HomePage extends StatelessWidget {
  final profilecontroller = Get.put(profileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<UserModel>>(
        future: profilecontroller
            .getAllUserDetails(), // Ensure this returns List<UserModel>
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<UserModel> users = snapshot.data!; // List of UserModel
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  UserModel userData = users[index]; // Access individual user
                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: AppColors.primaryColor,
                        child: Text(
                          userData.name[0]
                              .toUpperCase(), // First letter of the name
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        userData.name,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        userData.email,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      onTap: () {
                        // Action when tapped
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Tapped on ${userData.name}")),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else {
              return Center(
                child: Text(
                  "Something went wrong!",
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
