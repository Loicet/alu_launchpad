import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/opportunity_provider.dart';
import 'providers/application_provider.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/home_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OpportunityProvider()),
        ChangeNotifierProvider(create: (_) => ApplicationProvider()),
      ],
      child: MaterialApp(
        title: 'ALU LaunchPad',
        theme: ThemeData(
          primaryColor: const Color(0xFFE63946), // ALU Red
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Poppins',

          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0D1B3D), // ALU Navy
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
          ),

          cardTheme: CardThemeData(
            color: const Color(0xFFF2F4F7), // Light Gray
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE63946),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),

          chipTheme: ChipThemeData(
            backgroundColor: const Color(0xFFF2F4F7),
            labelStyle: const TextStyle(color: Colors.black87),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    debugPrint('AUTH WRAPPER: isLoggedIn=${authProvider.isLoggedIn} appUser=${authProvider.appUser?.role}');

    if (authProvider.isLoggedIn) {
      return const HomeRouter();
    }
    return const OnboardingScreen();
  }
}