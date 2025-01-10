import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/constant/AppColors.dart';
import 'package:lottie/lottie.dart';

import '../Models/UserModel.dart';
import '../controller/profileController.dart';
import 'User.dart';

class HomePage extends StatelessWidget {
  final profilecontroller = Get.put(ProfileController());
  final String? emailCurrentUser = FirebaseAuth.instance.currentUser?.email;

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
                  UserModel userData = users[index];
                  if (!userData.email.contains(emailCurrentUser.toString())) {
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
                          Get.to(Users(), arguments: {
                            'email': userData.email.toString(),
                            'name': userData.name.toString(),
                          });
                        },
                      ),
                    );
                  }
                  return null;
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
              child: Lottie.asset("assets/animations/loading.json"),
            );
          }
        },
      ),
    );
  }
}
