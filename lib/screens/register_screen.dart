import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../routes/app_routes.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Prototype: no real account is created yet.
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.chat,
        (route) => false,
        arguments: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create your account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Save your conversations and come back anytime.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 28),
                    AppTextField(
                      label: 'Name',
                      icon: Icons.person_outline,
                      controller: _name,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Enter your name'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Email',
                      icon: Icons.mail_outline,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v == null || !v.contains('@'))
                          ? 'Enter a valid email'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscure: true,
                      controller: _password,
                      validator: (v) => (v == null || v.length < 6)
                          ? 'At least 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Confirm password',
                      icon: Icons.lock_outline,
                      obscure: true,
                      controller: _confirm,
                      validator: (v) => v != _password.text
                          ? 'Passwords do not match'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    AppButton(label: 'Create account', onPressed: _submit),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, AppRoutes.login),
                        child: const Text('Already have an account? Log in'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}