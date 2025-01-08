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
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  final userRepo = Get.put(UserRepository());
  var userName = ''.obs;
  var selectedColor = '#000000'.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void updateColor(Color color) {
    final red = color.red.toRadixString(16).padLeft(2, '0');
    final green = color.green.toRadixString(16).padLeft(2, '0');
    final blue = color.blue.toRadixString(16).padLeft(2, '0');
    selectedColor.value = '#$red$green$blue';
  }

  void addUserData(UserDataModels userData) {
    userRepo.createUserData(userData);
  }

  void removeUserData(String userDataId) {
    userRepo.deleteUserData(userDataId);
  }
}
