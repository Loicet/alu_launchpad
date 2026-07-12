import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/opportunity_provider.dart';
import '../../models/opportunity_model.dart';
import 'view_applicants_screen.dart';

class PostingsScreen extends StatelessWidget {
  const PostingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final opportunityProvider = context.watch<OpportunityProvider>();
    final user = authProvider.appUser;

    return Scaffold(
      appBar: AppBar(title: const Text('My Postings')),
      body: StreamBuilder<List<Opportunity>>(
        stream: opportunityProvider.opportunitiesByStartup(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final opportunities = snapshot.data ?? [];
          if (opportunities.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'You haven\'t posted any opportunities yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: opportunities.length,
            itemBuilder: (context, index) {
              final opp = opportunities[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  title: Text(opp.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${opp.category} · ${opp.locationType} · ${opp.duration}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ViewApplicantsScreen(opportunity: opp)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}