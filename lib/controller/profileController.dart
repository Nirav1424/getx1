import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:getx/Models/UserModel.dart';
import 'package:getx/repository/UserRepository.dart';

class profileController extends GetxController {
  static profileController get instance => Get.find();

  final userRepo = Get.put(UserRepository());

  getUserDetails() {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      return userRepo.getUserDetails(email);
    } else {
      Get.snackbar("error", "Somthing wrong");
    }
  }

  Future<List<UserModel>> getAllUserDetails() async {
    return await userRepo.allUsers();
  }

  updateUser(UserModel user) async {
    await userRepo.updateUser(user);
  }
}
