import 'package:cloud_firestore/cloud_firestore.dart';

class Login_Service {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> validateCredentials(String employeeId, String password) async {
    try {
      // Fetch the employee document
      DocumentSnapshot employeeDoc = await _firestore.collection('employees').doc(employeeId).get();

      // Check if the employee exists and if the password matches
      if (employeeDoc.exists) {
        String storedPassword = employeeDoc['password'];
        return storedPassword == password; // Return true if passwords match
      }
      return false; // Employee ID does not exist
    } catch (e) {
      print("Error validating credentials: $e");
      return false; // Handle any errors during the fetch
    }
  }
}
