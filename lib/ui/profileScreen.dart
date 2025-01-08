import 'package:cloud_firestore/cloud_firestore.dart';
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

class profileScreen extends StatefulWidget {
  const profileScreen({super.key});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  final profilecontroller = Get.put(profileController());

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            Get.to(BottomNavigationScreen());
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text("Profile"),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(isDark ? Icons.sunny : Icons.dark_mode)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              FutureBuilder(
                future: profilecontroller.getUserDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      UserModel userData = snapshot.data as UserModel;
                      return Column(
                        children: [
                          Stack(children: [
                            CircleAvatar(
                              radius: 50,
                              child: Text(
                                userData.name[0],
                                style: TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.photo_camera)),
                            )
                          ]),
                          SizedBox(height: 16),
                          Text(
                            userData.name ?? "Name not available",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            userData.email ?? "Email not available",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                          ),
                          SizedBox(height: 24),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text("Phone Number"),
                            subtitle: Text(
                                userData.mobileNo ?? "Phone not available"),
                          ),
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text("Email"),
                            subtitle:
                                Text(userData.email ?? "Email not available"),
                          ),
                          ListTile(
                            leading: Icon(Icons.calendar_today),
                            title: Text("Joining date : "),
                            subtitle: Text(
                              userData.date != null
                                  ? DateFormat('MMMM d, y').format(
                                      (userData.date as Timestamp).toDate())
                                  : "Date not available",
                            ),
                          ),
                          Divider(),
                          SizedBox(height: 20),
                          CustomButton(
                              text: "Log Out",
                              onTap: () {
                                FirebaseAuth.instance.signOut().then((value) {
                                  Get.to(LoginScreen());
                                }).onError((error, stackTress) {
                                  Get.snackbar("error", error.toString());
                                });
                              }),
                        ],
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
