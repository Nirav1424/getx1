import 'package:get/get.dart';

class toggleCntrl extends GetxController {
  // To manage the "sold" state
  RxBool isSold = false.obs;

  // Toggle the "sold" state
  void toggleSold() {
    isSold.value = !isSold.value;
  }
}
