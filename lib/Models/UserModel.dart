import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String name;
  String email;
  String mobileNo;
  String? password;
  Timestamp? date;

  UserModel({
    this.id,
    this.date,
    required this.email,
    this.password,
    required this.name,
    required this.mobileNo,
  });

  /// Convert model to JSON for Firestore update
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'mobileNo': mobileNo,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }

  /// Create a model from Firestore document
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return UserModel(
      id: document.id,
      email: data?['email'] ?? '',
      password: data?['password'],
      name: data?['name'] ?? '',
      date: data?['date'],
      mobileNo: data?['mobileNo'] ?? '',
    );
  }
}
