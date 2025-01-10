import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditUserFormScreen extends StatelessWidget {
  final String userEmail; // Email of the user to fetch data for

  EditUserFormScreen({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit User'),
        ),
        body: Column(
          children: [
            // Name Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Email Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Phone Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 24),

            // Update Button
          ],
        ));
  }
}
