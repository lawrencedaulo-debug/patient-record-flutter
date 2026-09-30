import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/patient_model.dart';
import '../screens/patient_form_screen.dart';
import '../state/app_state.dart';

class PatientDetailScreen extends StatelessWidget {
  const PatientDetailScreen({required this.patient, super.key});

  final PatientModel patient;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PatientFormScreen(patient: patient),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: const Color(0xFF1F8A70),
                            child: Text(
                              patient.fullName.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  patient.fullName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text('Patient ID: ${patient.id}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _InfoRow(label: 'Age', value: '${patient.age}'),
              _InfoRow(label: 'Gender', value: patient.gender),
              _InfoRow(
                label: 'Date of Birth',
                value: DateFormat('MMM d, yyyy').format(patient.dateOfBirth),
              ),
              _InfoRow(label: 'Contact Number', value: patient.contactNumber),
              _InfoRow(label: 'Address', value: patient.address),
              _InfoRow(label: 'Medical History', value: patient.medicalHistory),
              _InfoRow(label: 'Allergies', value: patient.allergies),
              _InfoRow(
                label: 'Test Results',
                value: patient.testResults ?? 'Not added',
              ),
              _InfoRow(label: 'Notes', value: patient.notes ?? 'No notes'),
              _InfoRow(
                label: 'Date Added',
                value: DateFormat('MMM d, y').format(patient.createdAt),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.delete_forever_rounded),
                  onPressed: () async {
                    final choice = await showDialog<bool?>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete patient record?'),
                        content: const Text(
                          'Choose soft delete to hide it from active records, or permanent delete to remove it completely.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, null),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Soft delete'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Permanent delete'),
                          ),
                        ],
                      ),
                    );

                    if (choice == null || !context.mounted) {
                      return;
                    }

                    await appState.deletePatient(
                      patient,
                      softDelete: !choice,
                    );

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  label: const Text('Delete Record'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
