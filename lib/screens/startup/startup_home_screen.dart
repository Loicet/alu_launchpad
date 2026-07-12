import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/opportunity_provider.dart';
import '../../providers/application_provider.dart';
import '../../models/opportunity_model.dart';
import '../../models/application_model.dart';
import 'post_opportunity_screen.dart';
import 'postings_screen.dart';
import 'applicants_overview_screen.dart';
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
      const PostingsScreen(),
      const ApplicantsOverviewScreen(),
      const StartupProfileScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFE63946),
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Postings'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Applicants'),
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
    final applicationProvider = context.watch<ApplicationProvider>();
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
        builder: (context, oppSnapshot) {
          final opportunities = oppSnapshot.data ?? [];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(label: 'Active Opportunities', value: '${opportunities.length}'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StreamBuilder<List<Application>>(
                        stream: applicationProvider.applicationsForStartup(user.uid),
                        builder: (context, appSnapshot) {
                          final total = appSnapshot.data?.length ?? 0;
                          return _StatCard(label: 'Total Applicants', value: '$total');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Recent postings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                if (oppSnapshot.connectionState == ConnectionState.waiting)
                  const Center(child: CircularProgressIndicator())
                else if (opportunities.isEmpty)
                  const Text(
                    'You haven\'t posted any opportunities yet.',
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  ...opportunities.take(3).map((opp) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(opp.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${opp.locationType} · ${opp.duration}'),
                        ),
                      )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D1B3D))),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}