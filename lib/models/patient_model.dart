class PatientModel {
  PatientModel({
    required this.id,
    required this.tenantId,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.dateOfBirth,
    required this.contactNumber,
    required this.address,
    required this.medicalHistory,
    required this.allergies,
    this.testResults,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
  });

  final String id;
  final String tenantId;
  final String fullName;
  final int age;
  final String gender;
  final DateTime dateOfBirth;
  final String contactNumber;
  final String address;
  final String medicalHistory;
  final String allergies;
  final String? testResults;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final DateTime? deletedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenantId': tenantId,
      'fullName': fullName,
      'age': age,
      'gender': gender,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'contactNumber': contactNumber,
      'address': address,
      'medicalHistory': medicalHistory,
      'allergies': allergies,
      'testResults': testResults,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] as String,
      tenantId: json['tenantId'] as String,
      fullName: json['fullName'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      contactNumber: json['contactNumber'] as String,
      address: json['address'] as String,
      medicalHistory: json['medicalHistory'] as String,
      allergies: json['allergies'] as String,
      testResults: json['testResults'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
    );
  }

  PatientModel copyWith({
    String? id,
    String? tenantId,
    String? fullName,
    int? age,
    String? gender,
    DateTime? dateOfBirth,
    String? contactNumber,
    String? address,
    String? medicalHistory,
    String? allergies,
    String? testResults,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return PatientModel(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      allergies: allergies ?? this.allergies,
      testResults: testResults ?? this.testResults,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
