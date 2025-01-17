import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/constant/AppColors.dart';
import 'package:getx/constant/customeButton.dart';

import '../Models/UserDataModel.dart';
import '../controller/EditPropertyController.dart';

class EditPropertyPage extends StatelessWidget {
  const EditPropertyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditPropertyController controller = Get.put(EditPropertyController());

    final String id = Get.arguments['id']; // Get the property ID from arguments
    controller.fetchUserData(id); // Fetch data for the given ID

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Property'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final user = controller.user.value;

          // Controllers for input fields
          TextEditingController nameController =
              TextEditingController(text: user.name);
          TextEditingController addressController =
              TextEditingController(text: user.address);
          TextEditingController numberController =
              TextEditingController(text: user.number);
          TextEditingController amountController =
              TextEditingController(text: user.amount.toString());

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Circular Avatar with the property image
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("assets/images/Bungalow.webp"),
                    // Update with image URL or asset
                    // backgroundColor: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                // CustomInputField(
                //     controller: nameController, hintText: "property name"),

                // Property Name input field
                _buildInputField(nameController, 'Property Name',
                    'Please enter the property name'),

                const SizedBox(height: 16),

                // Property Location input field
                _buildInputField(addressController, 'Location',
                    'Please enter the property location'),

                const SizedBox(height: 16),

                // Property Price input field
                _buildInputField(amountController, 'Price',
                    'Please enter the property price',
                    keyboardType: TextInputType.number),

                const SizedBox(height: 16),

                // Property Number input field
                _buildInputField(numberController, 'Contact Number',
                    'Please enter the contact number',
                    keyboardType: TextInputType.number),

                const SizedBox(height: 20),

                // Update button
                CustomButton(
                  text: "Update Details",
                  onTap: () {
                    if (nameController.text.isNotEmpty &&
                        addressController.text.isNotEmpty &&
                        amountController.text.isNotEmpty &&
                        numberController.text.isNotEmpty) {
                      final updatedUser = UserDataModels(
                        id: user.id,
                        name: nameController.text,
                        address: addressController.text,
                        amount: int.parse(amountController.text),
                        number: numberController.text,
                      );
                      controller.updateProperty(updatedUser);
                    }
                    Get.back(); // Go back after updating
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Helper function to build input fields with uniform design
  Widget _buildInputField(
      TextEditingController controller, String label, String errorMessage,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
    );
  }
}
