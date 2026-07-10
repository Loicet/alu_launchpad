import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  final String role; // 'student' or 'startup'
  const SignupScreen({super.key, required this.role});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isStartup = widget.role == 'startup';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isStartup ? 'Create your startup account' : 'Create your student account',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Text(isStartup ? 'Startup / Organization Name' : 'Full Name',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: isStartup ? 'e.g. CodeCampus' : 'e.g. Favour Okoro',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              const Text('ALU Student Email', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'you@alustudent.com',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Password', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'At least 6 characters',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              if (isStartup) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Your startup will be marked unverified until an ALU admin confirms it.',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ],
              if (authProvider.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(authProvider.errorMessage!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE63946),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: authProvider.isLoading
                      ? null
                      : () async {
                          final email = _emailController.text.trim();

                          if (_nameController.text.trim().isEmpty ||
                              email.isEmpty ||
                              _passwordController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill in all fields')),
                            );
                            return;
                          }

                          if (!email.toLowerCase().endsWith('@alustudent.com')) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please use your ALU student email address (@alustudent.com)'),
                              ),
                            );
                            return;
                          }

                          await authProvider.signUp(
                            email: email,
                            password: _passwordController.text.trim(),
                            name: _nameController.text.trim(),
                            role: widget.role,
                          );
                          // AuthWrapper handles navigation automatically on success
                        },
                  child: authProvider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Sign Up', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}