import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/Route/routes.dart';

class SplaceScreen extends StatefulWidget {
  const SplaceScreen({super.key});

  @override
  State<SplaceScreen> createState() => _SplaceScreenState();
}

class _SplaceScreenState extends State<SplaceScreen> {
  // This widget is the root of your application.
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Navigate to the next screen after a delay
    Future.delayed(const Duration(seconds: 2), () {
      user != null
          ? Get.offAllNamed(RoutesClass.getBotomNav())
          : Get.offAllNamed(RoutesClass.getLogin());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // PNG Image
            Image.asset(
              'assets/images/ivon.png',
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 20),
            // Animated Text
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    "Ivon Tech Hub",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                      letterSpacing: value * 2,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
