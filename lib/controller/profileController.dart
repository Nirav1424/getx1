import 'package:get/get.dart';
import 'package:getx/Models/UserModel.dart';
import 'package:getx/repository/UserRepository.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final userRepo = Get.put(UserRepository());

  getUserDetails(String email) {
    return userRepo.getUserDetails(email);
  }

  Future<List<UserModel>> getAllUserDetails() async {
    return await userRepo.allUsers();
  }

  updateUser(UserModel user) async {
    await userRepo.updateUser(user);
  }
}
