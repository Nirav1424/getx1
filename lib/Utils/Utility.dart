import 'package:flutter/cupertino.dart';

class utility {
  static void feildFocusChange(
      BuildContext context, FocusNode current, FocusNode nextfocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextfocus);
  }
}
