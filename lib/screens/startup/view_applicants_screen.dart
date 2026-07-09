import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/application_provider.dart';
import '../../models/opportunity_model.dart';
import '../../models/application_model.dart';

class ViewApplicantsScreen extends StatelessWidget {
  final Opportunity opportunity;
  const ViewApplicantsScreen({super.key, required this.opportunity});

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'shortlisted':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final applicationProvider = context.watch<ApplicationProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Applicants · ${opportunity.title}')),
      body: StreamBuilder<List<Application>>(
        stream: applicationProvider.applicationsForOpportunity(opportunity.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No applicants yet'));
          }

          final applications = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final app = applications[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(app.studentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _statusColor(app.status).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              app.status,
                              style: TextStyle(color: _statusColor(app.status), fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(app.motivationLetter, maxLines: 3, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {}, // could open resumeLink in a browser later
                        child: Row(
                          children: [
                            const Icon(Icons.link, size: 16),
                            const SizedBox(width: 4),
                            const Text('View resume link', style: TextStyle(decoration: TextDecoration.underline)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => applicationProvider.updateStatus(app.id, 'shortlisted'),
                              child: const Text('Shortlist'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
                              onPressed: () => applicationProvider.updateStatus(app.id, 'accepted'),
                              child: const Text('Accept'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                              onPressed: () => applicationProvider.updateStatus(app.id, 'rejected'),
                              child: const Text('Reject'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}