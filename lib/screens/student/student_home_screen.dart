import 'package:flutter/material.dart';
import '../../screens/student/explore_screen.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreScreen()));
          },
          child: const Text('Explore Opportunities'),
        ),
      ),
    );
  }
}