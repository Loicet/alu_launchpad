import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/opportunity_provider.dart';
import '../../models/opportunity_model.dart';
import 'post_opportunity_screen.dart';
import 'view_applicants_screen.dart';
import 'startup_profile_screen.dart';

class StartupHomeScreen extends StatefulWidget {
  const StartupHomeScreen({super.key});

  @override
  State<StartupHomeScreen> createState() => _StartupHomeScreenState();
}

class _StartupHomeScreenState extends State<StartupHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _StartupHomeContent(),
      const StartupProfileScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFE63946),
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Profile'),
        ],
      ),
    );
  }
}

class _StartupHomeContent extends StatelessWidget {
  const _StartupHomeContent();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final opportunityProvider = context.watch<OpportunityProvider>();
    final user = authProvider.appUser;

    return Scaffold(
      appBar: AppBar(title: Text('Welcome, ${user?.name ?? ''}')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Post Opportunity'),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const PostOpportunityScreen()));
        },
      ),
      body: StreamBuilder<List<Opportunity>>(
        stream: opportunityProvider.opportunitiesByStartup(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'You haven\'t posted any opportunities yet.\nTap the button below to get started.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          final opportunities = snapshot.data!;

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
                  subtitle: Text('${opp.locationType} · ${opp.duration}'),
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