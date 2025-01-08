import 'package:flutter/material.dart';

import '../constant/AppColors.dart';

// Replace with your color constant file

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Image.asset(
              'assets/images/ivon.png',
              color: Colors.white,
              height: 150,
              width: 150,
            ),
          ),
          divider(),
          text("Home"),
          divider(),
          text("Our Services "),
          divider(),
          text("Our Projects "),
          divider(),
          text("Abous Us "),
          divider(),
          text("Contact US"),
          divider(),
          SizedBox(
            height: 35,
          ),
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "771 Whitehorse Road, Mont\n Albert  Australia",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "ivotechhub@gmail.com",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "+61 435 948 558",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Padding divider() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Divider(
        height: 1,
        color: Colors.white,
      ),
    );
  }

  Padding text(String name) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Text(
          name,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ));
  }
}
