import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/Route/routes.dart';
import 'package:getx/constant/AppColors.dart';
import 'package:getx/constant/customeButton.dart';
import 'package:getx/ui/viewPage.dart';
import 'package:intl/intl.dart';

import '../Models/UserDataModel.dart';
import '../controller/UserController.dart';
import '../controller/subcollection_controller.dart';
import '../repository/UserRepository.dart';
import 'AmountInputScreen.dart';
import 'DeleteWithTimerDialog.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final UserController userController = Get.put(UserController());
  final userRepo = Get.put(UserRepository());
  final SubcollectionController subcollectionController =
      Get.put(SubcollectionController()); //
  List<UserDataModels> userDataList = [];
  String colorCode = '';

  @override
  Widget build(BuildContext context) {
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
    final String name = arguments['name'] ?? 'Unknown Name';

    subcollectionController.fetchSubcollectionData(email);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: InkWell(
          onTap: () {
            // Get.to(profileScreen(), arguments: {'email': email});
          },
          child: Text(name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed(RoutesClass.getBotomNav());
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.call),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  // Handle search query change
                  print("Search Query: $value");
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
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
            Expanded(
              child: StreamBuilder<List<UserDataModels>>(
                stream: userRepo.getUserDataDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return Text('No data available');
                  } else {
                    userDataList = snapshot.data!;
                    return ListView.builder(
                      itemCount: userDataList.length,
                      itemBuilder: (context, index) {
                        final userData = userDataList[index];
                        if (email.contains(userData.name.toString())) {
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
                                    // Square Image
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/ivon.png"),
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
                                          Text(
                                            "Name: ${userData.name}", // Replace with actual name
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Address: ${userData.address}",
                                            // Replace with actual address
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Phone: +91 ${userData.number}",
                                            // Replace with actual phone number
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Divider(),
                                          Text(
                                            "Rent : \$ ${userData.amount}",
                                            // Replace with actual phone number
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
                                    // Action Buttons
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Three Dot Menu
                                        PopupMenuButton<String>(
                                          icon: const Icon(Icons.more_vert),
                                          onSelected: (value) {
                                            if (value == 'Edit') {
                                              // Handle Edit action
                                            } else if (value == 'Delete') {
                                              Get.dialog(
                                                  DeleteWithTimerDialog());
                                            } else if (value == 'View') {
                                              Get.to(ViewPage());
                                            } else if (value ==
                                                'Mark as Sold') {
                                              // Handle Mark as Sold action
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 'Mark as Sold',
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                // Space out text and icon
                                                children: [
                                                  const Text('Mark as Sold'),
                                                  Icon(Icons.done,
                                                      color: Colors.green),
                                                  // Green check icon
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'Delete',
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                // Space out text and icon
                                                children: [
                                                  const Text('Delete'),
                                                  Icon(Icons.delete,
                                                      color: Colors
                                                          .red), // Red delete icon
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'Edit',
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                // Space out text and icon
                                                children: [
                                                  const Text('Edit'),
                                                  Icon(Icons.edit,
                                                      color: Colors
                                                          .blue), // Blue edit icon
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'View',
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                // Space out text and icon
                                                children: [
                                                  const Text('View'),
                                                  Icon(Icons.remove_red_eye,
                                                      color: Colors.purple),
                                                  // Purple eye icon
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
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    );
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Expanded(
                      child: CustomButton(
                          color: userDataList.isNotEmpty
                              ? subcollectionController.totalAmount.value == 0
                                  ? AppColors.primaryColor
                                  : Colors.grey
                              : Colors.grey,
                          text: "delete all",
                          onTap: subcollectionController.totalAmount.value == 0
                              ? () {
                                  userController.removeAllData(email);
                                }
                              : () {})),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomButton(
                    color: AppColors.colorFailed,
                    text: "You Gave ₹ ",
                    onTap: () {
                      // userController.updateColor(AppColors.RED);

                      Get.to(() => AmountInputScreen(), arguments: {
                        'email': email,
                        'name': name,
                        'color': AppColors.REDTEXT,
                      });
                    },
                    height: 50,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    color: AppColors.colorSuccess,
                    text: "You Got ₹ ",
                    onTap: () {
                      // userController.updateColor(AppColors.GREEN);
                      Get.to(() => AmountInputScreen(), arguments: {
                        'email': email,
                        'name': name,
                        'color': AppColors.GREENTEXT,
                      });
                    },
                    height: 50,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
