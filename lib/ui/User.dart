import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/Route/routes.dart';
import 'package:getx/constant/AppColors.dart';
import 'package:getx/constant/customeButton.dart';
import 'package:intl/intl.dart';

import '../Models/UserDataModel.dart';
import '../controller/UserController.dart';
import '../controller/subcollection_controller.dart';
import '../repository/UserRepository.dart';
import 'AmountInputScreen.dart';

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
            Obx(() {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // Ensures spacing between the two texts
                    children: [
                      Text(
                        subcollectionController.totalAmount.value == 0
                            ? "Settled Up"
                            : (subcollectionController.tealColor.value >
                                    subcollectionController.redColor.value)
                                ? "You Will give"
                                : "You Will get ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '₹${subcollectionController.totalAmount.value.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: subcollectionController.totalAmount.value == 0
                              ? Colors.black
                              : (subcollectionController.tealColor.value >
                                      subcollectionController.redColor.value)
                                  ? AppColors.colorSuccess
                                  : AppColors.colorFailed,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
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
                          return Card(
                            child: ListTile(
                              title: Text(
                                DateFormat('dd MMM yy hh:mm a')
                                    .format(userData.date!.toDate()),
                                style: TextStyle(fontSize: 12),
                              ),
                              subtitle: Text(
                                'Amount :  ₹ ${userData.amount}  ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  // color: Color(int.parse(
                                  //         userData.color!.substring(1, 7),
                                  //         radix: 16) +
                                  //     0xFF000000),
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: AppColors.RED),
                                onPressed: () {
                                  if (userData.id != null) {
                                    userController.removeUserData(userData.id!);
                                  } else {
                                    Get.snackbar(
                                        "Error", "User data ID is null.");
                                  }
                                },
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
