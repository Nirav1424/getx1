import 'dart:async';

import 'package:get/get.dart';

import 'UserController.dart';

class DeleteTimerController extends GetxController {
  final UserController usercontroller = Get.put(UserController());

  var remainingTime = 30.obs;
  Timer? _timer;

  // Function to start the countdown timer
  void startTimer(String id) {
    remainingTime.value = 30;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel(); // Cancel the timer to prevent it from running again
        deleteItem(id);
        _timer?.cancel(); // Execute the else case
      }
    });
  }

  // Function to stop the countdown
  void cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

// Function to delete the item
  void deleteItem(String id) {
    usercontroller.removeUserData(id);

    Get.back(result: 'Deleted');
    print("Item deleted automatically after 60 seconds.");
  }

  @override
  void onClose() {
    cancelTimer(); // Ensure the timer is canceled when the controller is disposed
    super.onClose();
  }
}
