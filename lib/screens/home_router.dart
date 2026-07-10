import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'student/student_home_screen.dart';
import 'startup/startup_home_screen.dart';

class HomeRouter extends StatelessWidget {
  const HomeRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final role = authProvider.appUser?.role;

    if (role == null) {
      debugPrint('HOME ROUTER: role is null, appUser=${authProvider.appUser}');
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    debugPrint('HOME ROUTER: role=$role');
    if (role == 'startup') return const StartupHomeScreen();
    return const StudentHomeScreen();
  }
}