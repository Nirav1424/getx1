import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/DeleteTimerController.dart';
import '../controller/UserController.dart';

class DeleteWithTimerDialog extends StatelessWidget {
  final DeleteTimerController controller = Get.put(DeleteTimerController());
  final UserController usercontroller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments == null) {
      // Handle null arguments gracefully
      return Scaffold(
        body: Center(
          child: Text("No data provided!"),
        ),
      );
    }
    final String id = arguments['id'] ?? 'Unknown id';

    controller.cancelTimer();
    controller.startTimer(id);

    return AlertDialog(
      title: Text('Are you sure you want to delete?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return Text(
                'You have ${controller.remainingTime} seconds left to cancel the deletion.');
          }),
          SizedBox(height: 20),
          Obx(() {
            return LinearProgressIndicator(
              value: controller.remainingTime.value / 30,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            );
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            controller.cancelTimer();
            controller.remainingTime.value = 30;
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            controller.cancelTimer();
            controller.remainingTime.value = 30;
            controller.deleteItem(id);
          },
          child: Text('Delete Now'),
        ),
      ],
    );
  }
}
