// lib/pages/auth_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../utils/test_helper.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // Properly initialized here
  bool _isLogin = true;
  bool _isLoading = false;

  // Test methods
  Future<void> _runAuthTests() async {
    await _testRegistration(
      email: 'test@example.com',
      password: 'TestPassword123!',
    );
  }

  Future<void> _testRegistration({
    required String email,
    required String password,
  }) async {
    try {
      await _authService.registerWithEmailAndPassword(email, password);
      AuthTestHelper.printTestResult(
        'Registration',
        true,
        'Successfully registered user',
      );
    } catch (e) {
      AuthTestHelper.printTestResult(
        'Registration',
        false,
        'Error: ${e.toString()}',
      );
    }
  }

  Future<void> _testLogin({
    required String email,
    required String password,
  }) async {
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      AuthTestHelper.printTestResult(
        'Login',
        true,
        'Successfully logged in user',
      );
    } catch (e) {
      AuthTestHelper.printTestResult(
        'Login',
        false,
        'Error: ${e.toString()}',
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        if (_isLogin) {
          await _authService.signInWithEmailAndPassword(
            _emailController.text,
            _passwordController.text,
          );
        } else {
          await _authService.registerWithEmailAndPassword(
            _emailController.text,
            _passwordController.text,
          );
          _showVerificationDialog();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Verify Your Email'),
          content: const Text(
            'A verification email has been sent. Please verify your email before signing in.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _authService.resendVerificationEmail();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Verification email resent')),
                );
              },
              child: const Text('Resend Email'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _isLogin = true);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Register'),
        actions: [
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.bug_report),
              onPressed: _runAuthTests,
              tooltip: 'Run Auth Tests',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter an email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a password' : null,
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(_isLogin ? 'Login' : 'Register'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(
                  _isLogin
                      ? 'Need an account? Register'
                      : 'Have an account? Login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
