import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget leptop;
  final Widget tablet;
  final Widget phone;

  const Responsive({
    Key? key,
    required this.tablet,
    required this.phone,
    required this.leptop,
  }) : super(key: key);

  static bool isPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > 600 &&
        MediaQuery.of(context).size.width < 1200;
  }

  static bool isLeptop(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      if (Constraints.maxWidth > 1200) {
        return leptop;
      } else if (Constraints.maxWidth <= 1200 && Constraints.maxWidth >= 600) {
        return tablet ?? leptop;
      } else {
        return phone ?? leptop;
      }
    });
  }
}
