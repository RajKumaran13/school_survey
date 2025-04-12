// lib/view/register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:school_survey/features/register_page/view_model/register_store.dart';
import 'package:school_survey/utils/colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final store = RegisterStore();

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white10,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.purpleAccent),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildPasswordIcon() {
    return Observer(
      builder: (_) {
        if (store.confirmPassword.isEmpty) return const SizedBox();
        return Icon(
          store.passwordsMatch ? Icons.check_circle : Icons.cancel,
          color: store.passwordsMatch ? Colors.green : Colors.red,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlack,
        title: const Text(
          'Register',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Observer(
            builder: (_) => ListView(
              children: [
                TextFormField(
                  style: const TextStyle(color: AppColors.primaryWhite),
                  decoration: _inputDecoration('Name'),
                  onChanged: store.setName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  style: const TextStyle(color: AppColors.primaryWhite),
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration('Mobile Number'),
                  onChanged: store.setMobile,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  style: const TextStyle(color: AppColors.primaryWhite),
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration('Email'),
                  onChanged: store.setEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  style: const TextStyle(color: AppColors.primaryWhite),
                  obscureText: true,
                  decoration: _inputDecoration('Password'),
                  onChanged: store.setPassword,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  style: const TextStyle(color: AppColors.primaryWhite),
                  obscureText: true,
                  decoration: _inputDecoration('Re-enter Password').copyWith(
                    suffixIcon: _buildPasswordIcon(),
                  ),
                  onChanged: store.setConfirmPassword,
                ),
                const SizedBox(height: 30),
                store.isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.purpleAccent))
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE040FB),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: store.allFieldsValid
                            ? () async {
                                final success = await store.registerUser();
                                if (success && mounted) context.go('/');
                                if (!success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Registration failed")),
                                  );
                                }
                              }
                            : null,
                        child: const Text('Register', style: TextStyle(fontSize: 16, color: AppColors.primaryWhite, fontWeight: FontWeight.w800)),
                      ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
