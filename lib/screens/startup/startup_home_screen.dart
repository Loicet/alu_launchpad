import 'package:flutter/material.dart';
import '../../screens/startup/post_opportunity_screen.dart';

class StartupHomeScreen extends StatelessWidget {
  const StartupHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Startup Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PostOpportunityScreen()));
          },
          child: const Text('Post New Opportunity'),
        ),
      ),
    );
  }
}