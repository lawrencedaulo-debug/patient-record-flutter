import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/patient_model.dart';
import '../state/app_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final patients = appState.tenantPatients;
    final users = appState.tenantUsers;

    final totalPatients = patients.length;
    final monthNow = DateTime.now();
    final patientsThisMonth = patients.where((patient) {
      return patient.createdAt.year == monthNow.year &&
          patient.createdAt.month == monthNow.month;
    }).length;

    final recentPatients = [...patients]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            GridView.count(
              shrinkWrap: true,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _StatCard(
                  title: 'Total Patients',
                  value: totalPatients.toString(),
                  color: const Color(0xFF1F8A70),
                  icon: Icons.people_alt_rounded,
                ),
                _StatCard(
                  title: 'This Month',
                  value: patientsThisMonth.toString(),
                  color: const Color(0xFF3B82F6),
                  icon: Icons.calendar_month_rounded,
                ),
                _StatCard(
                  title: 'Active Users',
                  value: users.length.toString(),
                  color: const Color(0xFFF59E0B),
                  icon: Icons.person_add_alt_1_rounded,
                ),
                _StatCard(
                  title: 'Recent Records',
                  value: recentPatients.take(5).length.toString(),
                  color: const Color(0xFF8B5CF6),
                  icon: Icons.receipt_long_rounded,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Most recent records',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (recentPatients.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No patient records yet. Add your first patient.'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentPatients.length > 5 ? 5 : recentPatients.length,
                itemBuilder: (context, index) {
                  final patient = recentPatients[index];
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
                      subtitle: Text(
                        'Added ${DateFormat('MMM d, y').format(patient.createdAt)}',
                      ),
                      trailing: Text(patient.gender),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String title;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
