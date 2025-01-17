import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx/Models/UserModel.dart';

import '../Models/UserDataModel.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final db = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
  }

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

  Future<void> updateUserDataProperties(UserDataModels user) async {
    await db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("userData")
        .doc(user.id)
        .update(user.toJson());
  }

  Future<void> createUserData(UserDataModels userData) async {
    await db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("userData")
        .doc()
        .set(userData.toJson())
        .catchError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
    });
  }

  Future<void> createUserDataAllUser(UserDataModels userData) async {
    await db
        .collection("users1")
        .doc()
        .set(userData.toJson())
        .catchError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
    });
  }

  // RxList<UserDataModels> filteredUserData = <UserDataModels>[].obs;
  // RxString searchQuery = ''.obs;
  // TextEditingController serchController = TextEditingController();

  Stream<List<UserDataModels>> getUserDataDetails() {
    final userDataCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('userData')
        .orderBy('date', descending: true);

    return userDataCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => UserDataModels.fromSnapshot(doc))
          .toList();
    });
  }

  Stream<UserDataModels?> getOnlySelectedData(String id) {
    final documentSnapshotStream = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('userData')
        .doc(id)
        .snapshots();

    return documentSnapshotStream.map((documentSnapshot) {
      if (documentSnapshot.exists) {
        return UserDataModels.fromSnapshot(documentSnapshot);
      } else {
        return null;
      }
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

  Future<void> deleteUserDataWithEmail(String email) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('userData')
          .where('name', isEqualTo: email)
          .get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      Get.snackbar("Success", "Data deleted");
    } catch (error) {
      Get.snackbar("Error", "Failed to delete data: $error");
    }
  }
}
