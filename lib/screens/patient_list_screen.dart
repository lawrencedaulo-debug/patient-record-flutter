import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/patient_model.dart';
import '../screens/patient_detail_screen.dart';
import '../screens/patient_form_screen.dart';
import '../state/app_state.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'date';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final query = _searchController.text.trim().toLowerCase();

    var patients = appState.tenantPatients.where((patient) {
      if (query.isEmpty) {
        return true;
      }
      final searchableText = '${patient.fullName} ${patient.id}'.toLowerCase();
      return searchableText.contains(query);
    }).toList();

    if (_sortBy == 'name') {
      patients.sort((a, b) => a.fullName.compareTo(b.fullName));
    } else {
      patients.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PatientFormScreen()),
          );
        },
        label: const Text('Add Patient'),
        icon: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search by name or patient ID',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: _sortBy,
                    items: const [
                      DropdownMenuItem(value: 'date', child: Text('Date added')),
                      DropdownMenuItem(value: 'name', child: Text('Name')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _sortBy = value);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ${patients.length}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: patients.isEmpty
                    ? const Center(
                        child: Text('No patient records found in this clinic.'),
                      )
                    : ListView.separated(
                        itemCount: patients.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final patient = patients[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF1F8A70),
                                child: Text(
                                  patient.fullName.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(patient.fullName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: ${patient.id}'),
                                  Text('Age: ${patient.age} • ${patient.gender}'),
                                  Text(
                                    'Added: ${DateFormat('MMM d, y').format(patient.createdAt)}',
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PatientDetailScreen(
                                      patient: patient,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
