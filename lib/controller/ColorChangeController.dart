import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorChangeController extends GetxController {
  // Observable variable for the text color
  var textColor = Colors.black.obs;

  // Method to change text color
  void changeTextColor(Color color) {
    textColor.value = color;
  }
}
