import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Models/UserDataModel.dart';
import '../repository/UserRepository.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var nameController = TextEditingController();
  var amountController = TextEditingController();
  var amount = RxString('0');
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  final userRepo = Get.put(UserRepository());
  var userName = ''.obs;
  var selectedColor = '#000000'.obs;
  final RxDouble totalBalance = 0.0.obs; // Reactive double
  final RxBool isButtonEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();

    amountController.addListener(() {
      amount.value = amountController.text;
      isButtonEnabled.value = amountController.text.isNotEmpty;
    });
  }

  @override
  void onClose() {
    // amountController.dispose();

    super.onClose();
  }

  void updateColor(Color color) {
    final red = color.red.toRadixString(16).padLeft(2, '0');
    final green = color.green.toRadixString(16).padLeft(2, '0');
    final blue = color.blue.toRadixString(16).padLeft(2, '0');
    selectedColor.value = '#$red$green$blue';
  }

  // void updateBalance(int val, String operation) {
  //   print('Current Balance: ${totalBalance.value}');
  //   print('Operation: $operation, Value: $val');
  //
  //   double currentBalance = totalBalance.value;
  //   if (operation == 'ADD') {
  //     currentBalance += val;
  //   } else if (operation == 'MINUS') {
  //     currentBalance -= val;
  //   }
  //   totalBalance.value = currentBalance;
  //
  //   print('Updated Balance: ${totalBalance.value}');
  // }

  void addUserData(UserDataModels userData) {
    userRepo.createUserData(userData);
  }

  void removeUserData(String userDataId) {
    userRepo.deleteUserData(userDataId);
  }

  void removeAllData(String email) {
    userRepo.deleteUserDataWithEmail(email);
  }
}
