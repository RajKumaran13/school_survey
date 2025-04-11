// lib/pages/register_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordsMatch = false;
  bool _allFieldsValid = false;
  bool _isLoading = false;

  void _checkFormValidity() {
    setState(() {
      _passwordsMatch = _passwordController.text == _confirmPasswordController.text &&
          _passwordController.text.isNotEmpty;

      _allFieldsValid = _nameController.text.isNotEmpty &&
          _mobileController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordsMatch;
    });
  }

  Future<void> _registerUser() async {
    setState(() => _isLoading = true);
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = userCredential.user;
      

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'mobile': _mobileController.text.trim(),
        });
      }

      if (mounted) context.go('/');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration failed')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildPasswordIcon() {
    if (_confirmPasswordController.text.isEmpty) return const SizedBox();
    return Icon(
      _passwordsMatch ? Icons.check_circle : Icons.cancel,
      color: _passwordsMatch ? Colors.green : Colors.red,
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Register', style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Name'),
                onChanged: (_) => _checkFormValidity(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mobileController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration('Mobile Number'),
                onChanged: (_) => _checkFormValidity(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Email'),
                onChanged: (_) => _checkFormValidity(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                decoration: _inputDecoration('Password'),
                onChanged: (_) => _checkFormValidity(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                decoration: _inputDecoration('Re-enter Password').copyWith(
                  suffixIcon: _buildPasswordIcon(),
                ),
                onChanged: (_) => _checkFormValidity(),
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.purpleAccent))
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _allFieldsValid ? _registerUser : null,
                      child: const Text('Register', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w800)),
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
    );
  }
}


// // lib/pages/register_page.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _mobileController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _passwordsMatch = false;
//   bool _allFieldsValid = false;
//   bool _isLoading = false;

//   void _checkFormValidity() {
//     setState(() {
//       _passwordsMatch = _passwordController.text == _confirmPasswordController.text &&
//           _passwordController.text.isNotEmpty;

//       _allFieldsValid =
//           _nameController.text.isNotEmpty &&
//           _mobileController.text.isNotEmpty &&
//           _emailController.text.isNotEmpty &&
//           _passwordsMatch;
//     });
//   }

//   Future<void> _registerUser() async {
//   setState(() => _isLoading = true);
//   try {
//     final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: _emailController.text.trim(),
//       password: _passwordController.text.trim(),
//     );

//     final user = userCredential.user;

//     if (user != null) {
//       // Save additional data to Firestore
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//         'name': _nameController.text.trim(),
//         'email': _emailController.text.trim(),
//         'mobile': _mobileController.text.trim(),
//       });
//     }

//     if (mounted) context.go('/landing');
//   } on FirebaseAuthException catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(e.message ?? 'Registration failed')),
//     );
//   } finally {
//     setState(() => _isLoading = false);
//   }
// }


//   @override
//   void dispose() {
//     _nameController.dispose();
//     _mobileController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Widget _buildPasswordIcon() {
//     if (_confirmPasswordController.text.isEmpty) return const SizedBox();
//     return Icon(
//       _passwordsMatch ? Icons.check_circle : Icons.cancel,
//       color: _passwordsMatch ? Colors.green : Colors.red,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Register')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Name'),
//                 onChanged: (_) => _checkFormValidity(),
//               ),
//               TextFormField(
//                 controller: _mobileController,
//                 keyboardType: TextInputType.phone,
//                 decoration: const InputDecoration(labelText: 'Mobile Number'),
//                 onChanged: (_) => _checkFormValidity(),
//               ),
//               TextFormField(
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 onChanged: (_) => _checkFormValidity(),
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(labelText: 'Password'),
//                 onChanged: (_) => _checkFormValidity(),
//               ),
//               TextFormField(
//                 controller: _confirmPasswordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Re-enter Password',
//                   suffixIcon: _buildPasswordIcon(),
//                 ),
//                 onChanged: (_) => _checkFormValidity(),
//               ),
//               const SizedBox(height: 20),
//               if (_allFieldsValid && !_isLoading)
//                 ElevatedButton(
//                   onPressed: _registerUser,
//                   child: const Text('Register'),
//                 ),
//               if (_isLoading) const Center(child: CircularProgressIndicator()),
//               const SizedBox(height: 10),
//               TextButton(
//                 onPressed: () => context.go('/'),
//                 child: const Text('Already have an account? Login'),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
