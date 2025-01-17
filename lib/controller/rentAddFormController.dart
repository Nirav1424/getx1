import 'package:get/get.dart';

class FormController extends GetxController {
  // Observables for form fields
  var name = ''.obs;
  var address = ''.obs;
  var phoneNo = ''.obs;
  var rentPrice = ''.obs;

  // Function to clear the form
  void clearForm() {
    name.value = '';
    address.value = '';
    phoneNo.value = '';
    rentPrice.value = '';
  }

  // Function to handle form submission
  void submitForm() {
    // You can replace this with your logic to save the data
    print("Name: ${name.value}");
    print("Address: ${address.value}");
    print("Phone Number: ${phoneNo.value}");
    print("Rent Price: ${rentPrice.value}");
  }
}
