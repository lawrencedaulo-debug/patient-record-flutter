import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/patient_model.dart';
import '../state/app_state.dart';

class PatientFormScreen extends StatefulWidget {
  const PatientFormScreen({this.patient, super.key});

  final PatientModel? patient;

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _ageController;
  late final TextEditingController _contactController;
  late final TextEditingController _addressController;
  late final TextEditingController _medicalHistoryController;
  late final TextEditingController _allergiesController;
  late final TextEditingController _testResultsController;
  late final TextEditingController _notesController;

  String _selectedGender = 'Male';
  DateTime? _selectedDob;

  @override
  void initState() {
    super.initState();
    final patient = widget.patient;
    _fullNameController = TextEditingController(text: patient?.fullName ?? '');
    _ageController = TextEditingController(text: patient?.age.toString() ?? '');
    _contactController = TextEditingController(text: patient?.contactNumber ?? '');
    _addressController = TextEditingController(text: patient?.address ?? '');
    _medicalHistoryController =
        TextEditingController(text: patient?.medicalHistory ?? '');
    _allergiesController = TextEditingController(text: patient?.allergies ?? '');
    _testResultsController = TextEditingController(text: patient?.testResults ?? '');
    _notesController = TextEditingController(text: patient?.notes ?? '');
    _selectedGender = patient?.gender ?? 'Male';
    _selectedDob = patient?.dateOfBirth;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _ageController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _medicalHistoryController.dispose();
    _allergiesController.dispose();
    _testResultsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (date != null) {
      setState(() => _selectedDob = date);
    }
  }

  Future<void> _savePatient() async {
    if (!_formKey.currentState!.validate() || _selectedDob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }

    final now = DateTime.now();
    final patient = PatientModel(
      id: widget.patient?.id ?? now.millisecondsSinceEpoch.toString(),
      tenantId: widget.patient?.tenantId ?? '',
      fullName: _fullNameController.text.trim(),
      age: int.tryParse(_ageController.text.trim()) ?? 0,
      gender: _selectedGender,
      dateOfBirth: _selectedDob!,
      contactNumber: _contactController.text.trim(),
      address: _addressController.text.trim(),
      medicalHistory: _medicalHistoryController.text.trim(),
      allergies: _allergiesController.text.trim(),
      testResults: _testResultsController.text.trim().isEmpty
          ? null
          : _testResultsController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: widget.patient?.createdAt ?? now,
      updatedAt: now,
      isDeleted: widget.patient?.isDeleted ?? false,
      deletedAt: widget.patient?.deletedAt,
    );

    await context.read<AppState>().savePatient(patient);
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.patient != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit patient record' : 'Register patient'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'Full name is required'
                          : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Age'),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'Age is required'
                                : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: const InputDecoration(labelText: 'Gender'),
                        items: const [
                          DropdownMenuItem(value: 'Male', child: Text('Male')),
                          DropdownMenuItem(
                              value: 'Female', child: Text('Female')),
                          DropdownMenuItem(value: 'Other', child: Text('Other')),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedGender = value ?? 'Male');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _selectDate,
                  borderRadius: BorderRadius.circular(14),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDob == null
                              ? 'Select date'
                              : DateFormat('MMM d, y').format(_selectedDob!),
                        ),
                        const Icon(Icons.calendar_today_outlined),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Contact Number'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _medicalHistoryController,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(labelText: 'Medical History'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _allergiesController,
                  decoration: const InputDecoration(labelText: 'Allergies'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _testResultsController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Test Results'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Medical Notes'),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _savePatient,
                  icon: const Icon(Icons.save_rounded),
                  label: Text(isEditing ? 'Update record' : 'Save patient'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
