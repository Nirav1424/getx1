import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:getx/Models/UserModel.dart';

import '../Models/UserDataModel.dart';

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

  Future<void> createUserData(UserDataModels userData) async {
    await db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("userData")
        .doc()
        .set(userData.toJson())
        .whenComplete(
            () => Get.snackbar("Success", "Your data has been created!"))
        .catchError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
    });
  }

  Stream<List<UserDataModels>> getUserDataDetails() {
    final userDataCollection = FirebaseFirestore.instance
        .collection('users') // Access the `users` collection
        .doc(
            FirebaseAuth.instance.currentUser?.uid) // Specify the user document
        .collection('userData'); // Access the `userData` subcollection

    return userDataCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => UserDataModels.fromSnapshot(doc))
          .toList();
    });
  }

  Future<void> deleteUserData(String userDataId) async {
    try {
      await db
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('userData')
          .doc(userDataId)
          .delete()
          .whenComplete(() => Get.snackbar("Success", "Data deleted"))
          .catchError((error) {
        Get.snackbar("Error", error.toString());
      });
    } catch (error) {
      Get.snackbar("Error", "Failed to delete data: $error");
    }
  }
}
