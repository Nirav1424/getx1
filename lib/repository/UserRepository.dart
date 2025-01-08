import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:getx/Models/UserModel.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await db
        .collection("users")
        .doc(user.id)
        .set(user.toJson())
        .whenComplete(
            () => Get.snackbar("succcess", "Your account has been created !"))
        .catchError((error, stackTrece) {
      Get.snackbar("error", error.toString());
    });
  }

  Future<UserModel> getUserDetails(String email) async {
    final snepshot =
        await db.collection("users").where("email", isEqualTo: email).get();
    final userData = snepshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<List<UserModel>> allUsers() async {
    final snepshot = await db.collection("users").get();
    final userData =
        snepshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  Future<void> updateUser(UserModel user) async {
    await db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(user.toJson());
  }
}
