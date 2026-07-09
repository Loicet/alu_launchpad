import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/opportunity_provider.dart';
import '../../models/opportunity_model.dart';

class PostOpportunityScreen extends StatefulWidget {
  const PostOpportunityScreen({super.key});

  @override
  State<PostOpportunityScreen> createState() => _PostOpportunityScreenState();
}

class _PostOpportunityScreenState extends State<PostOpportunityScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _skillsController = TextEditingController(); // comma-separated
  String _category = 'Development';
  String _locationType = 'Remote';
  String _duration = '3 months';
  bool _isPosting = false;

  final List<String> _categories = ['Development', 'Design', 'Marketing', 'Business'];
  final List<String> _durations = ['1 month', '2 months', '3 months', '4+ months'];

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty || _descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in title and description')),
      );
      return;
    }

    setState(() => _isPosting = true);

    final authProvider = context.read<AuthProvider>();
    final opportunityProvider = context.read<OpportunityProvider>();
    final user = authProvider.appUser!;

    final opportunity = Opportunity(
      id: '', // Firestore assigns this on .add()
      startupId: user.uid,
      startupName: user.name,
      title: _titleController.text.trim(),
      category: _category,
      locationType: _locationType,
      duration: _duration,
      description: _descController.text.trim(),
      skills: _skillsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
      createdAt: DateTime.now(),
    );

    await opportunityProvider.postOpportunity(opportunity);

    setState(() => _isPosting = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post New Opportunity')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Job Title', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'e.g. Flutter Developer Intern',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _category = val!),
            ),
            const SizedBox(height: 20),
            const Text('Location Type', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Remote', 'On-site', 'Hybrid'].map((type) {
                return ChoiceChip(
                  label: Text(type),
                  selected: _locationType == type,
                  onSelected: (_) => setState(() => _locationType = type),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text('Duration', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _duration,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              items: _durations.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (val) => setState(() => _duration = val!),
            ),
            const SizedBox(height: 20),
            const Text('Required Skills (comma-separated)', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _skillsController,
              decoration: InputDecoration(
                hintText: 'e.g. Flutter, Firebase, Git',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Job Description', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Describe the role, responsibilities, and what you\'re looking for...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE63946),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _isPosting ? null : _submit,
                child: _isPosting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Post Opportunity', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}