import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/opportunity_model.dart';
import '../../models/application_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/application_provider.dart';

class ApplyScreen extends StatefulWidget {
  final Opportunity opportunity;
  const ApplyScreen({super.key, required this.opportunity});

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  final _resumeLinkController = TextEditingController();
  final _letterController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (_resumeLinkController.text.trim().isEmpty || _letterController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a resume link and a motivation letter')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final authProvider = context.read<AuthProvider>();
    final applicationProvider = context.read<ApplicationProvider>();
    final user = authProvider.appUser!;

    final application = Application(
      id: '',
      opportunityId: widget.opportunity.id,
      opportunityTitle: widget.opportunity.title,
      startupId: widget.opportunity.startupId,
      studentId: user.uid,
      studentName: user.name,
      resumeLink: _resumeLinkController.text.trim(),
      motivationLetter: _letterController.text.trim(),
      appliedAt: DateTime.now(),
    );

    await applicationProvider.submitApplication(application);

    setState(() => _isSubmitting = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application submitted!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Apply for ${widget.opportunity.title}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.opportunity.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(widget.opportunity.startupName, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            const Text('Resume Link', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('Paste a Google Drive / Dropbox link to your resume', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: _resumeLinkController,
              decoration: InputDecoration(
                hintText: 'https://drive.google.com/...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Motivation Letter', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _letterController,
              maxLines: 6,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Tell the startup why you\'re a great fit for this role...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE63946),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Submit Application', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}