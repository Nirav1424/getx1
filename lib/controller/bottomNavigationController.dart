// bottom_navigation_controller.dart
import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  // The index for BottomNavigationBar
  var selectedIndex = 0.obs;

  // Update the selected index when a bottom nav item is tapped
  void updateIndex(int index) {
    selectedIndex.value = index;
  }
}
