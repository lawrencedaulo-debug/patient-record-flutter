import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/patient_model.dart';
import '../models/user_model.dart';

class AppStorage {
  static const String _usersKey = 'patient_record_users';
  static const String _patientsKey = 'patient_record_patients';
  static const String _currentUserKey = 'patient_record_current_user';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<UserModel>> loadUsers() async {
    final rawData = _prefs.getStringList(_usersKey) ?? <String>[];
    return rawData
        .map((data) => UserModel.fromJson(Map<String, dynamic>.from(jsonDecode(data))))
        .toList();
  }

  Future<void> saveUsers(List<UserModel> users) async {
    final encoded = users
        .map((user) => jsonEncode(user.toJson()))
        .toList(growable: false);
    await _prefs.setStringList(_usersKey, encoded);
  }

  Future<List<PatientModel>> loadPatients() async {
    final rawData = _prefs.getStringList(_patientsKey) ?? <String>[];
    return rawData
        .map((data) =>
            PatientModel.fromJson(Map<String, dynamic>.from(jsonDecode(data))))
        .toList();
  }

  Future<void> savePatients(List<PatientModel> patients) async {
    final encoded = patients
        .map((patient) => jsonEncode(patient.toJson()))
        .toList(growable: false);
    await _prefs.setStringList(_patientsKey, encoded);
  }

  Future<String?> loadCurrentUserId() async {
    return _prefs.getString(_currentUserKey);
  }

  Future<void> saveCurrentUserId(String? userId) async {
    if (userId == null) {
      await _prefs.remove(_currentUserKey);
      return;
    }

    await _prefs.setString(_currentUserKey, userId);
  }
}
