import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/FavController.dart';

class listViewScreen extends StatefulWidget {
  const listViewScreen({super.key});

  @override
  State<listViewScreen> createState() => _listViewScreenState();
}

class _listViewScreenState extends State<listViewScreen> {
  FavController controller = Get.put(FavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: controller.Fruite.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                    onTap: () {
                      if (controller.Fav.contains(
                          controller.Fruite[index].toString())) {
                        controller.Fav.remove(
                            controller.Fruite[index].toString());
                      } else {
                        controller.Fav.add(controller.Fruite[index].toString());
                      }
                    },
                    title: Text(controller.Fruite[index].toString()),
                    leading: Obx(() {
                      return Icon(
                        Icons.favorite,
                        color: controller.Fav.contains(
                                controller.Fruite[index].toString())
                            ? Colors.red
                            : Colors.white,
                      );
                    })),
              );
            }));
  }
}
