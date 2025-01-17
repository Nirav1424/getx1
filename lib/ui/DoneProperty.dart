import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/Models/UserModel.dart';
import 'package:getx/constant/customeButton.dart';
import 'package:getx/controller/profileController.dart';
import 'package:intl/intl.dart';

import '../constant/AppColors.dart';
import '../controller/UserController.dart';
import '../repository/UserRepository.dart';
import 'LoginScreen.dart';

class DoneProperty extends StatelessWidget {
  final profilecontroller = Get.put(ProfileController());
  final UserController userController = Get.put(UserController());
  final userRepo = Get.put(UserRepository());
  final purchesref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("userData")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    final String? email = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      body: FutureBuilder<UserModel>(
        future: profilecontroller.getUserDetails(email.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "No data found for this user.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final userData = snapshot.data!;

          return Column(
            children: [
              // User Profile Card
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.grey.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: AppColors.secondryColor,
                              child: Text(
                                userData.name[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    userData.email,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '+91 ${userData.mobileNo}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.calendar_today,
                              color: AppColors.secondryColor),
                          title: const Text(
                            "Joining Date",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            userData.date != null
                                ? DateFormat('MMMM d, y')
                                    .format(userData.date!.toDate())
                                : "Date not available",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomButton(
                          height: 40.0,
                          color: AppColors.secondryColor,
                          text: "Log Out",
                          onTap: () {
                            FirebaseAuth.instance.signOut().then((value) {
                              Get.offAll(LoginScreen());
                            }).onError((error, stackTrace) {
                              Get.snackbar("Error", error.toString());
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(thickness: 1),
              // User List
              Expanded(
                child: Obx(() {
                  final searchText =
                      userController.searchQuery.value.toLowerCase();

                  return StreamBuilder<QuerySnapshot>(
                    stream: purchesref,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No data available'));
                      } else {
                        final filteredUsers = snapshot.data!.docs.where((doc) {
                          final name = doc.get('name')?.toString() ?? '';
                          final address = doc.get('address')?.toString() ?? '';
                          return name.toLowerCase().contains(searchText) ||
                              address.toLowerCase().contains(searchText);
                        }).toList();

                        if (filteredUsers.isEmpty) {
                          return const Center(
                              child: Text('No matching results'));
                        }

                        return ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            final name = user.get('name') ?? 'Unknown';
                            final address = user.get('address') ?? 'No address';
                            final number = user.get('number') ?? 'N/A';
                            final amount = user.get('amount') ?? 0;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      // Square Image Placeholder
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // User Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Name
                                            Text(
                                              "Name: $name",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // Address
                                            Text(
                                              "Address: ${address.length > 30 ? address.substring(0, 30) + "..." : address}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // Phone Number
                                            Text(
                                              "+91 $number",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Divider(),
                                            // Rent
                                            Text(
                                              "Rent: \$$amount",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
