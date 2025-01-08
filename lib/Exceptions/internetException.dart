import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/constant/AppColors.dart';
import 'package:getx/constant/customeButton.dart';
import 'package:getx/ui/Setting.dart';

class internetExceptionScreen extends StatefulWidget {
  const internetExceptionScreen({super.key});

  @override
  State<internetExceptionScreen> createState() =>
      _internetExceptionScreenState();
}

class _internetExceptionScreenState extends State<internetExceptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 80, color: AppColors.primaryColor),
          SizedBox(height: 20),
          Text(
            "No Internet Connection",
            style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 100,
            child: CustomButton(text: "retry", onTap: () {}),
          ),
          // ElevatedButton(
          //   onPressed: () {},
          //   child: Text("Retry"),
          // ),
        ],
      ),
    );
  }
}
