import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String name;
  final String email;
  final String mobileNo;
  final String? password;
  final Timestamp? date;

  const UserModel({
    this.id,
    this.date,
    required this.email,
    this.password,
    required this.name,
    required this.mobileNo,
  });

  toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'mobileNo': mobileNo,
      'date': DateTime.now()
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return UserModel(
        id: document.id,
        email: data?['email'],
        password: data?['password'],
        name: data?['name'],
        date: data?['date'],
        mobileNo: data?['mobileNo']);
  }
}
