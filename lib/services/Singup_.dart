import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signup_Service {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _generateEmployeeId() {
    const prefix = 'emp_id_';
    const int length = 15;
    const int idLength = length - prefix.length; 

    
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    String randomId = List.generate(idLength, (index) => chars[random.nextInt(chars.length)]).join();

    return '$prefix$randomId';
  }

  Future<bool> registerEmployee({
    required String fullName,
    required String department,
    required String position,
    required double salaryPerDay,
    required String dateOfJoining,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    try {
      // Create a unique employee ID
      String employeeId = _generateEmployeeId();

      // Save employee data in Firestore
      await _firestore.collection('employees').doc(employeeId).set({
        'employeeId': employeeId,
        'fullName': fullName,
        'department': department,
        'position': position,
        'salaryPerDay': salaryPerDay,
        'dateOfJoining': dateOfJoining,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password,
      });
      print("Employee registered successfully.");
      return true;
    } catch (e) {
      print("Error registering employee: $e");
      return false; 
    }
  }
}
