import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../routes/app_routes.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Prototype: no real authentication yet.
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
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "We're glad you're here.",
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 28),
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
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Enter your password'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    AppButton(label: 'Log in', onPressed: _submit),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, AppRoutes.register),
                        child: const Text("No account yet? Create one"),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.chat,
                          (route) => false,
                          arguments: true,
                        ),
                        child: const Text('Continue as guest'),
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