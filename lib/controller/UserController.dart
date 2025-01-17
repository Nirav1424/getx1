import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Models/UserDataModel.dart';
import '../repository/UserRepository.dart';

class UserController extends GetxController {
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  final userRepo = Get.put(UserRepository());

  final RxDouble totalBalance = 0.0.obs; // Reactive double
  final RxBool isButtonEnabled = false.obs;

  var addressController = TextEditingController();
  var numberController = TextEditingController();
  var nameController = TextEditingController();
  var amountController = TextEditingController();

  var filteredUserData = <UserDataModels>[].obs;

  var searchQuery = ''.obs;
  late TextEditingController searchController;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    searchController.addListener(() {
      updateSearchQuery(searchController.text); // Sync with observable
    });
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Filters the user data list based on search query
  // void filterUsers(List<UserDataModels> userDataList) {
  //   if (searchQuery.value.isEmpty) {
  //     filteredUserData.assignAll(userDataList);
  //   } else {
  //     filteredUserData.assignAll(
  //       userDataList.where((user) {
  //         return user.name
  //                     .toLowerCase()
  //                     .contains(searchQuery.value.toLowerCase()) ||
  //                 user.address!
  //                     .toLowerCase()
  //                     .contains(searchQuery.value.toLowerCase()) ??
  //             false;
  //       }).toList(),
  //     );
  //   }
  // }

  void addUserData(UserDataModels userData) {
    userRepo.createUserData(userData);
  }

  void addUserDataAllUser(UserDataModels userData) {
    userRepo.createUserDataAllUser(userData);
  }

  void removeUserData(String userDataId) {
    userRepo.deleteUserData(userDataId);
  }

  void removeAllData(String email) {
    userRepo.deleteUserDataWithEmail(email);
  }
}
