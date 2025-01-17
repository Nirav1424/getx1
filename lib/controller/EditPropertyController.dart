import '../Models/UserDataModel.dart';
import '../repository/UserRepository.dart';
import 'package:get/get.dart';

class EditPropertyController extends GetxController {
  final UserRepository userRepo = Get.find<UserRepository>();

  var user =
      UserDataModels(id: '', name: '', address: '', amount: 0, number: '').obs;

  // Fetch data for a specific property
  void fetchUserData(String id) {
    userRepo.getOnlySelectedData(id).listen((data) {
      if (data != null) {
        user.value = data;
      }
    });
  }

  // Update property details
  Future<void> updateProperty(UserDataModels updatedUser) async {
    await userRepo.updateUserDataProperties(updatedUser);
  }
}
