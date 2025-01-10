import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/Models/UserModel.dart';
import 'package:getx/constant/customeButton.dart';
import 'package:getx/controller/profileController.dart';
import 'package:intl/intl.dart';

import '../constant/AppColors.dart';
import 'LoginScreen.dart';
import 'bottomNavigationBar.dart';

class profileScreen extends StatelessWidget {
  final profilecontroller = Get.put(ProfileController());
  final String? emailCurrentUser = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            Get.offAll(BottomNavigationScreen());
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(isDark ? Icons.sunny : Icons.dark_mode),
          ),
        ],
      ),
      body: FutureBuilder<UserModel>(
        future: profilecontroller.getUserDetails(email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                "No data found for this user.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final userData = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Picture and Edit Icon
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryColor.withOpacity(0.5),
                      child: Text(
                        userData.name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: emailCurrentUser == email
                          ? IconButton(
                              onPressed: () {
                                // // Navigate to edit profile screen
                                // Get.to(EditProfileScreen(), arguments: userData);
                              },
                              icon: Icon(Icons.edit,
                                  color: AppColors.primaryColor),
                            )
                          : Container(),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // User Information
                Text(
                  userData.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  userData.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 24),
                Divider(),
                // Additional Details
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text("Phone Number"),
                  subtitle: Text(userData.mobileNo),
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text("Email"),
                  subtitle: Text(userData.email),
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text("Joining Date"),
                  subtitle: Text(
                    userData.date != null
                        ? DateFormat('MMMM d, y')
                            .format(userData.date!.toDate())
                        : "Date not available",
                  ),
                ),
                Divider(),
                SizedBox(height: 20),
                // Logout Button
                emailCurrentUser == userData.email
                    ? CustomButton(
                        text: "Log Out",
                        onTap: () {
                          FirebaseAuth.instance.signOut().then((value) {
                            Get.offAll(LoginScreen());
                          }).onError((error, stackTrace) {
                            Get.snackbar("Error", error.toString());
                          });
                        },
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}
