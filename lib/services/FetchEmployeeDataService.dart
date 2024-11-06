// FetchEmployeeDataService.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchEmployeeDataService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchEmployeeById(String employeeId) async {
    try {
      DocumentSnapshot snapshot = await firestore.collection('employees').doc(employeeId).get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        return null; // Employee not found
      }
    } catch (e) {
      print("Error fetching employee: $e");
      return null; // Handle the error accordingly
    }
  }
}
