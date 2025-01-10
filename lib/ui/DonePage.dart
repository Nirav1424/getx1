import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/constant/customeButton.dart';
import 'package:getx/ui/AmountInputScreen.dart';
import 'package:lottie/lottie.dart';

import '../constant/AppColors.dart';

class DonePage extends StatefulWidget {
  @override
  _DonePageState createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate a short delay for a smooth transition
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (arguments == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "No data provided!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    final String email = arguments['email'] ?? 'Unknown Email';
    final String name = arguments['name'] ?? 'Unknown Name';
    final String amount = arguments['amount1'] ?? '0';
    print('Extracted amount: $amount');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top half: Green background with success icon and message
          Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: double.infinity,
                color: AppColors.colorSuccess,
                padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 100,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Transaction Successful!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Transaction for $name has been completed.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Text(
                    //   '₹ $amount',
                    //   style: TextStyle(
                    //     fontSize: 25,
                    //     color: Colors.white,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                  ],
                ),
              ),
              Lottie.asset("assets/animations/Animation.json", repeat: false)
            ],
          ),

          // Bottom half: Buttons
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Informational text
                  Text(
                    "Would you like to add another transaction for $name?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.off(
                              () => AmountInputScreen(),
                              arguments: {
                                'email': email,
                                'name': name,
                                'color': AppColors.REDTEXT,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.colorFailed,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "YOU GAVE ₹",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.off(
                              () => AmountInputScreen(),
                              arguments: {
                                'email': email,
                                'name': name,
                                'color': AppColors.GREENTEXT,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.colorSuccess,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "YOU GOT ₹",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  CustomButton(
                      text: "Done",
                      onTap: () {
                        Get.back();
                      }),

                  // Done button
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: ElevatedButton(
                  //         onPressed: () {
                  //           Get.back();
                  //         },
                  //         style: ElevatedButton.styleFrom(
                  //           backgroundColor: Colors.blue[800],
                  //           padding: EdgeInsets.symmetric(vertical: 16),
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(12),
                  //           ),
                  //         ),
                  //         child: Text(
                  //           "Done",
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
