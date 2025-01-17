import 'package:get/get.dart';
import 'package:getx/ui/LoginScreen.dart';
import 'package:getx/ui/SignUpScreen.dart';
import 'package:getx/ui/bottomNavigationBar.dart';

import '../ui/spaceScreen.dart';

class RoutesClass {
  static String spalce = "/";
  static String BottomNavigation = "/BottomNavigation";
  static String login = "/login";
  static String signup = "/signup";
  static String profile = "/profile";

  static String getHomeRoute() => spalce;

  static String getBotomNav() => BottomNavigation;

  static String getLogin() => login;

  static String getSignup() => signup;

  static String getProfile() => profile;

  static List<GetPage> routes = [
    GetPage(name: spalce, page: () => const SplaceScreen()),
    GetPage(name: BottomNavigation, page: () => BottomNavigationScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: signup, page: () => SignUpScreen()),
    // GetPage(name: profile, page: () => profileScreen())
  ];
}
