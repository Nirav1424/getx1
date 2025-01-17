import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/constant/AppColors.dart';
import 'package:getx/ui/DoneProperty.dart';
import 'package:getx/ui/Setting.dart';

import '../controller/bottomNavigationController.dart';
import 'DrawerScreen.dart';
import 'Home.dart';

class BottomNavigationScreen extends StatelessWidget {
  // Initialize the controller
  final BottomNavigationController bottomNavController =
      Get.put(BottomNavigationController());
  final auth = FirebaseAuth.instance;
  final String? email = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home Page'),
        backgroundColor: AppColors.primaryColor,
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         Get.toNamed(RoutesClass.getProfile(),
        //             arguments: {'email': email});
        //       },
        //       icon: Icon(Icons.person))
        // ],
      ),
      drawer: CustomDrawer(),
      body: Obx(() {
        // Return the widget based on the selected index
        switch (bottomNavController.selectedIndex.value) {
          case 0:
            return rentPage();
          case 1:
            return salePage();
          case 2:
            return DoneProperty();
          default:
            return rentPage();
        }
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          selectedItemColor: AppColors.primaryColor,
          currentIndex: bottomNavController.selectedIndex.value,
          onTap: (index) {
            bottomNavController
                .updateIndex(index); // Update the index when the item is tapped
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance),
              label: 'Rent',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Sale',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_task),
              label: 'Done',
            ),
          ],
        );
      }),
    );
  }
}
