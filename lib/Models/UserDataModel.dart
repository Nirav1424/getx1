import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModels {
  final String? id;
  final String name;
  final int amount;
  final int? totalAmount;
  final Timestamp? date;
  final String? color;
  const UserDataModels({
    this.id,
    this.date,
    this.color,
    this.totalAmount,
    required this.amount,
    required this.name,
  });

  toJson() {
    return {
      'name': name,
      'amount': amount,
      'date': DateTime.now(),
      'color': color,
      'totalAmount': totalAmount,
    };
  }

  factory UserDataModels.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return UserDataModels(
        id: document.id,
        name: data?['name'],
        date: data?['date'],
        totalAmount: data?['totalAmount'],
        color: data?['color'] ?? '#000000',
        amount: (data?['amount']).toInt());
  }
}
