import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/countController.dart';
import 'listViewScreen.dart';

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  final controller = Get.put(countController());
  bool notification = false;

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Obx(() => Text(controller.count.toString())),
          ),
          Obx(() {
            return Center(
              child: Container(
                height: 300,
                width: 300,
                color: Colors.red.withOpacity(controller.opacity.value),
              ),
            );
          }),
          Obx(() => Slider(
              value: controller.opacity.value,
              onChanged: (val) {
                controller.setValue(val);
              })),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Dark Mode "),
                Switch(
                    value: controller.notification.value,
                    onChanged: (val) {
                      controller.notification.value = val;
                      controller.notification.value == true
                          ? Get.changeTheme(ThemeData.dark())
                          : Get.changeTheme(ThemeData.light());
                    }),
                // ElevatedButton(
                //     onPressed: () {
                //       Get.changeTheme(ThemeData.dark());
                //     },
                //     child: Text("dark")),
                // ElevatedButton(
                //     onPressed: () {
                //       Get.changeTheme(ThemeData.light());
                //     },
                //     child: Text("light"))
              ],
            );
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.increment();
          Get.to(listViewScreen());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
