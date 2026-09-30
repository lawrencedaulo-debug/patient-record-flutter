import 'package:flutter/foundation.dart';

import '../models/patient_model.dart';
import '../models/user_model.dart';
import '../services/app_storage.dart';

class AppState extends ChangeNotifier {
  AppState() : _storage = AppStorage();

  final AppStorage _storage;

  List<UserModel> _users = <UserModel>[];
  List<PatientModel> _patients = <PatientModel>[];
  UserModel? currentUser;

  bool get isLoggedIn => currentUser != null;

  List<UserModel> get users => List.unmodifiable(_users);
  List<PatientModel> get allPatients => List.unmodifiable(_patients);

  List<PatientModel> get tenantPatients {
    if (currentUser == null) {
      return const <PatientModel>[];
    }

    final tenantPatients = _patients
        .where((patient) =>
            patient.tenantId == currentUser!.tenantId && !patient.isDeleted)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return tenantPatients;
  }

  List<UserModel> get tenantUsers {
    if (currentUser == null) {
      return const <UserModel>[];
    }

    return _users
        .where((user) => user.tenantId == currentUser!.tenantId)
        .toList();
  }

  Future<void> initialize() async {
    await _storage.init();

    _users = await _storage.loadUsers();
    if (_users.isEmpty) {
      _users = <UserModel>[UserModel.defaultAdmin()];
      await _storage.saveUsers(_users);
    }

    _patients = await _storage.loadPatients();

    final currentUserId = await _storage.loadCurrentUserId();
    if (currentUserId != null) {
      for (final user in _users) {
        if (user.id == currentUserId) {
          currentUser = user;
          break;
        }
      }
    }

    notifyListeners();
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();
    final matchUser = _findUserByEmail(cleanEmail);

    if (matchUser == null) {
      return 'No account found for that email.';
    }

    if (matchUser.password != password) {
      return 'Incorrect password.';
    }

    currentUser = matchUser;
    await _storage.saveCurrentUserId(matchUser.id);
    notifyListeners();
    return null;
  }

  Future<String?> register({
    required String name,
    required String tenantName,
    required String email,
    required String password,
  }) async {
    final cleanName = name.trim();
    final cleanTenantName = tenantName.trim();
    final cleanEmail = email.trim();

    if (cleanName.isEmpty ||
        cleanTenantName.isEmpty ||
        cleanEmail.isEmpty ||
        password.isEmpty) {
      return 'Please complete all fields.';
    }

    if (_users.any((user) =>
        user.email.toLowerCase() == cleanEmail.toLowerCase())) {
      return 'An account already exists for this email.';
    }

    final tenantId = _sanitizeTenantId(cleanTenantName);
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: cleanName,
      email: cleanEmail,
      password: password,
      tenantId: tenantId,
      tenantName: cleanTenantName,
      role: 'user',
      createdAt: DateTime.now(),
    );

    _users.add(user);
    await _storage.saveUsers(_users);
    currentUser = user;
    await _storage.saveCurrentUserId(user.id);
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    currentUser = null;
    await _storage.saveCurrentUserId(null);
    notifyListeners();
  }

  Future<void> savePatient(PatientModel patient) async {
    if (currentUser == null) {
      return;
    }

    final tenantPatient = patient.copyWith(tenantId: currentUser!.tenantId);
    final index = _patients.indexWhere((item) => item.id == tenantPatient.id);

    if (index >= 0) {
      _patients[index] = tenantPatient;
    } else {
      _patients.add(tenantPatient);
    }

    await _storage.savePatients(_patients);
    notifyListeners();
  }

  Future<void> deletePatient(PatientModel patient, {required bool softDelete}) async {
    final index = _patients.indexWhere((item) => item.id == patient.id);
    if (index < 0) {
      return;
    }

    if (softDelete) {
      _patients[index] = patient.copyWith(
        isDeleted: true,
        deletedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } else {
      _patients.removeAt(index);
    }

    await _storage.savePatients(_patients);
    notifyListeners();
  }

  UserModel? _findUserByEmail(String email) {
    for (final user in _users) {
      if (user.email.toLowerCase() == email.toLowerCase()) {
        return user;
      }
    }
    return null;
  }

  String _sanitizeTenantId(String tenantName) {
    final cleaned = tenantName
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');

    return cleaned.isEmpty ? 'clinic' : cleaned;
  }
}
