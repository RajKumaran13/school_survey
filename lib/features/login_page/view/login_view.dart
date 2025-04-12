// lib/view/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:school_survey/features/login_page/view_modal/login_store.dart';
import 'package:school_survey/utils/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginStore _store = LoginStore();
  final _resetEmailController = TextEditingController();

  void _showResetPasswordSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Reset Password",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryWhite),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _resetEmailController,
              style: const TextStyle(color: AppColors.primaryWhite),
              decoration: InputDecoration(
                labelText: "Enter your email",
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white24),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primaryPurple),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: AppColors.primaryWhite,
              ),
              onPressed: () async {
                final success = await _store.sendResetEmail(_resetEmailController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? "Password reset email sent" : "Failed to send email")),
                );
              },
              child: const Text("Reset Password"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        title: const Text('Login',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryBlack),
        ),
        backgroundColor: AppColors.primaryPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Observer(
          builder: (_) => ListView(
            children: [
              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryWhite),
              ),
              const SizedBox(height: 30),
              TextField(
                onChanged: _store.setEmail,
                style: const TextStyle(color: AppColors.primaryWhite),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.primaryPurple),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: true,
                onChanged: _store.setPassword,
                style: const TextStyle(color: AppColors.primaryWhite),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.primaryPurple),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  final success = await _store.login();
                  if (success && mounted) {
                    context.go('/landing');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(_store.errorMessage)),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _store.isLoading
                    ? const CircularProgressIndicator(color: AppColors.primaryWhite)
                    : const Text('Login', style: TextStyle(fontSize: 16, color: AppColors.primaryWhite, fontWeight: FontWeight.w800)),
              ),
              TextButton(
                onPressed: _showResetPasswordSheet,
                child: const Text('Forgot Password?', style: TextStyle(color: Colors.white70)),
              ),
              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text('Don\'t have an account? Register', style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
