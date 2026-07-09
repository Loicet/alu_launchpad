import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/opportunity_provider.dart';
import '../../models/opportunity_model.dart';
import 'opportunity_details_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final _categories = ['All', 'Development', 'Design', 'Marketing', 'Business'];

  @override
  Widget build(BuildContext context) {
    final opportunityProvider = context.watch<OpportunityProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Explore Opportunities')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search by role, skill or keyword...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _categories.map((cat) {
                final selected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    selectedColor: const Color(0xFFE63946),
                    labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<List<Opportunity>>(
              stream: opportunityProvider.allOpportunities,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No opportunities posted yet'));
                }

                var opportunities = snapshot.data!;

                // Filter by category
                if (_selectedCategory != 'All') {
                  opportunities = opportunities.where((o) => o.category == _selectedCategory).toList();
                }
                // Filter by search text (title or skills)
                if (_searchQuery.isNotEmpty) {
                  opportunities = opportunities.where((o) {
                    return o.title.toLowerCase().contains(_searchQuery) ||
                        o.skills.any((s) => s.toLowerCase().contains(_searchQuery));
                  }).toList();
                }

                if (opportunities.isEmpty) {
                  return const Center(child: Text('No matches found'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: opportunities.length,
                  itemBuilder: (context, index) {
                    final opp = opportunities[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text(opp.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(opp.startupName),
                            const SizedBox(height: 4),
                            Text('${opp.locationType} · ${opp.duration}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => OpportunityDetailsScreen(opportunity: opp)),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}