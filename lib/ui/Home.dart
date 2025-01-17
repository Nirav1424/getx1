import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/constant/AppColors.dart';
import 'package:getx/ui/viewPage.dart';
import 'package:intl/intl.dart';

import '../controller/UserController.dart';
import '../controller/markAsDoneToggleController.dart';
import '../repository/UserRepository.dart';
import 'AddRnetDetailsPage.dart';
import 'DeleteWithTimerDialog.dart';
import 'editProperty.dart';

class rentPage extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final userRepo = Get.put(UserRepository());
  final toggleContoller = Get.put(toggleCntrl());
  final purchesref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("userData")
      .snapshots();

  rentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search TextField
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: userController.searchController,
                onChanged: (value) => userController.updateSearchQuery(value),
                decoration: InputDecoration(
                  hintText: 'Search Properties',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            // Data List
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
                        return const Center(child: Text('No matching results'));
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
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8, left: 6, right: 6),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    // Square Image
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/Bungalow.webp"),
                                          fit: BoxFit.cover,
                                        ),
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
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: "Name: ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors
                                                        .black, // You can set the color as needed
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: (name ?? "").length > 10
                                                      ? "${name.substring(0, 10)}..."
                                                      : name ?? "",
                                                  // Use a default value if userData.name is null
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    // Normal weight for the name
                                                    color: Colors
                                                        .black87, // You can set the color as needed
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8),

                                          // Address (with truncation)
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Address Icon
                                              const Icon(
                                                Icons.location_on,
                                                color: Colors.grey,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              // Space between icon and text
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Address:",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        // Make the label bold
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    // Space between label and value
                                                    Tooltip(
                                                      message: address ?? "",
                                                      // Show full address on hover/tap
                                                      child: Text(
                                                        (address ?? "").length >
                                                                30
                                                            ? "${address.substring(0, 30)}..."
                                                            : address ?? "",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors
                                                              .black87, // Change color for better contrast
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),

                                          // Phone Number
                                          Text(
                                            "+91 $number",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Divider(),

                                          // Rent
                                          Text(
                                            "\$ ${NumberFormat("#,##,###").format(amount)}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Action Buttons (Menu and Share)
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // Three Dot Menu
                                        PopupMenuButton<String>(
                                          icon: Icon(Icons.more_vert),
                                          onSelected: (value) {
                                            if (value == 'Edit') {
                                              Get.to(EditPropertyPage(),
                                                  arguments: {'id': user.id});
                                            } else if (value == 'Delete') {
                                              Get.dialog(
                                                  DeleteWithTimerDialog(),
                                                  arguments: {'id': user.id});
                                            } else if (value == 'View') {
                                              Get.to(ViewPage(),
                                                  arguments: {'id': user.id});
                                            } else if (value ==
                                                'Mark as Sold') {
                                              toggleContoller.toggleSold();
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 'Mark as Sold',
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Mark as Sold'),
                                                  Obx(
                                                    () {
                                                      // Watch the `isSold` state and change the icon accordingly
                                                      return Icon(
                                                        toggleContoller
                                                                .isSold.value
                                                            ? Icons.add
                                                            : Icons.check,
                                                        color: Colors.green,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'Delete',
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const [
                                                  Text('Delete'),
                                                  Icon(Icons.delete,
                                                      color: Colors.red),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'Edit',
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const [
                                                  Text('Edit'),
                                                  Icon(Icons.edit,
                                                      color: Colors.blue),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'View',
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const [
                                                  Text('View'),
                                                  Icon(Icons.remove_red_eye,
                                                      color: Colors.purple),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Share Button
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.share,
                                              color: AppColors.primaryColor),
                                        ),
                                      ],
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Get.to(() => Addrnetdetailspages());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
