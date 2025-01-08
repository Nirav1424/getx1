import 'package:get/get.dart';
import 'package:flutter/material.dart';

class countController extends GetxController {
  RxInt count = 0.obs;
  RxDouble opacity = 0.4.obs;
  RxBool notification = false.obs;
  void increment() {
    count.value++;
  }

  void setValue(val) {
    opacity.value = val;
  }

  void changeNoti(bool val) {
    notification.value = val;
  }
}
