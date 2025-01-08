import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/ui/bottomNavigationBar.dart';
import 'package:getx/ui/spaceScreen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Get.snackbar("welcome", "nirav");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    print('user is  ${user?.email}');
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),

      home: user == null ? SplaceScreen() : BottomNavigationScreen(),
      // getPages: AppRoutes.appRouts(),
    );
  }
}
