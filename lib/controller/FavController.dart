import 'package:get/get.dart';

class FavController extends GetxController {
  RxList<String> Fruite =
      ['mango', 'greps', 'Apple', 'Stobary', 'Watermalen'].obs;
  RxList Fav = [].obs;

  addFav(String val) {
    Fav.add(val);
  }

  removeFav(String val) {
    Fav.remove(val);
  }
}
