import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Models/UserDataModel.dart';
import '../Route/routes.dart';
import '../constant/AppColors.dart';
import '../constant/customeButton.dart';
import '../controller/UserController.dart';
import '../controller/subcollection_controller.dart';
import '../repository/UserRepository.dart';
import '../ui/profileScreen.dart';
import 'AmountInputScreen.dart';

class Users1 extends StatefulWidget {
  const Users1({Key? key}) : super(key: key);

  @override
  State<Users1> createState() => _UsersState();
}

class _UsersState extends State<Users1> {
  final UserController userController = Get.put(UserController());
  final userRepo = Get.put(UserRepository());
  final SubcollectionController subcollectionController =
      Get.put(SubcollectionController());
  List<UserDataModels> userDataList = [];

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments == null) {
      return Scaffold(
        body: Center(
          child: Text("No data provided!", style: TextStyle(fontSize: 18)),
        ),
      );
    }

    final String email = arguments['email'] ?? 'Unknown Email';
    final String name = arguments['name'] ?? 'Unknown Name';

    subcollectionController.fetchSubcollectionData(email);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: InkWell(
            onTap: () {
              Get.to(profileScreen(), arguments: {'email': email});
            },
            child: Text(
              name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
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
        body: Column(
          children: [
            // Balance Summary Section
            Container(
              color: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Obx(() {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subcollectionController.totalAmount.value == 0
                              ? "Settled Up"
                              : subcollectionController.tealColor.value >
                                      subcollectionController.redColor.value
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: subcollectionController.totalAmount.value ==
                                    0
                                ? Colors.black
                                : subcollectionController.tealColor.value >
                                        subcollectionController.redColor.value
                                    ? AppColors.colorSuccess
                                    : AppColors.colorFailed,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            // User Data List Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<List<UserDataModels>>(
                  stream: userRepo.getUserDataDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No data available'));
                    } else {
                      userDataList = snapshot.data!;
                      return ListView.builder(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        itemCount: userDataList.length,
                        itemBuilder: (context, index) {
                          final userData = userDataList[index];
                          if (email.contains(userData.name.toString())) {
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(
                                  DateFormat('dd MMM yy hh:mm a')
                                      .format(userData.date!.toDate()),
                                  style: TextStyle(fontSize: 12),
                                ),
                                subtitle: Text(
                                  'Amount: ₹${userData.amount}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(
                                      int.parse(
                                            userData.color!.substring(1, 7),
                                            radix: 16,
                                          ) +
                                          0xFF000000,
                                    ),
                                  ),
                                ),
                                trailing: IconButton(
                                  icon:
                                      Icon(Icons.delete, color: AppColors.RED),
                                  onPressed: () {
                                    if (userData.id != null) {
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
                            return SizedBox.shrink();
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ),
            // Action Buttons Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => CustomButton(
                        color: userDataList.isNotEmpty &&
                                subcollectionController.totalAmount.value == 0
                            ? AppColors.primaryColor
                            : Colors.grey,
                        text: "Delete All",
                        onTap: userDataList.isNotEmpty
                            ? subcollectionController.totalAmount.value == 0
                                ? () {
                                    userController.removeAllData(email);
                                  }
                                : () {}
                            : () {},
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      color: AppColors.colorFailed,
                      text: "You Gave ₹",
                      onTap: () {
                        userController.updateColor(AppColors.RED);
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
                      text: "You Got ₹",
                      onTap: () {
                        userController.updateColor(AppColors.GREEN);
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
            ),
          ],
        ),
      ),
    );
  }
}
