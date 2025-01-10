import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:getx/constant/AppColors.dart';

class SubcollectionController extends GetxController {
  var totalAmount = 0.0.obs;
  var tealColor = 0.0.obs;
  var redColor = 0.0.obs;
  var filteredDataList = <Map<String, dynamic>>[].obs;

  void fetchSubcollectionData(String email) {
    try {
      final users = FirebaseFirestore.instance.collection('users');

      users
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('userData')
          .where('name', isEqualTo: email)
          .snapshots()
          .listen((querySnapshot) {
        double total = 0.0;
        double red = 0.0;
        double teal = 0.0;
        List<Map<String, dynamic>> dataList = [];

        // Process each document in the snapshot
        for (var subDoc in querySnapshot.docs) {
          var data = subDoc.data();

          // Add the document's data to the list
          dataList.add(data);

          // Extract the amount and color
          double amount = (data['amount'] ?? 0).toDouble();
          String color = data['color'] ?? '';

          // Update totals based on the color
          if (color == AppColors.fetchRedColorCode) {
            // Red color
            red += amount;
          } else if (color == AppColors.fetchGreenColorCode) {
            // Teal color
            teal += amount;
          }
        }

        // Calculate total amount as the absolute difference
        total = (red - teal).abs();

        // Update reactive variables
        filteredDataList.value = dataList;
        totalAmount.value = total;
        tealColor.value = teal;
        redColor.value = red;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching subcollection data: $e");
      }
    }
  }
}
