import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModels {
  final String? id;
  final String name;
  final int amount;
  final String? number;
  final int? totalAmount;
  final Timestamp? date;
  final String? address;
  final String? email;

  const UserDataModels({
    this.id,
    this.date,
    this.address,
    this.totalAmount,
    this.number,
    this.email,
    required this.amount,
    required this.name,
  });

  toJson() {
    return {
      'name': name,
      'amount': amount,
      'number': number,
      'date': DateTime.now(),
      'address': address,
      'totalAmount': totalAmount,
      'email': email,
    };
  }

  factory UserDataModels.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return UserDataModels(
        id: document.id,
        name: data?['name'],
        date: data?['date'],
        number: data?['number'],
        email: data?['email'],
        totalAmount: data?['totalAmount'] ?? 0,
        address: data?['address'] ?? 'null',
        amount: (data?['amount']).toInt());
  }
}
