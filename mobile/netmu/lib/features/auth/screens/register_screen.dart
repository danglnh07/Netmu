import "package:flutter/material.dart";
import "package:netmu/core/themes/theme.dart";
import "package:netmu/core/widgets/button.dart";
import "package:netmu/core/widgets/error_message.dart";
import "package:netmu/core/widgets/form_label.dart";
import "package:netmu/core/widgets/input.dart";
import "package:netmu/features/auth/models/register_dto.dart";
import "package:netmu/features/auth/services/auth_service.dart";
import "package:netmu/features/auth/widgets/auth_form_footer.dart";



class RegisterScreen extends StatefulWidget {
  final AuthService _service = AuthService();

  RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Loading button state
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegister() async {
    if (_formKey.currentState!.validate()) {
      // Set loading state
      setState(() => _isLoading = true);

      // Make request
      final username = _usernameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      final request = RegisterRequest(
        username: username,
        email: email,
        password: password,
      );
      var (success, message) = await widget._service.register(request);

      // Whether request failed or not, we both set loading state to false
      setState(() => _isLoading = false);

      // Check if success or not
      if (mounted) {
        if (!success) {
            ScaffoldMessenger.of(context).showSnackBar(
              ErrorMessage(textContent: message!)
            );
          return;
        }

        // If success, redirect to login
        Navigator.pushNamedAndRemoveUntil(context, "/auth/login", (route) => false);
      }
    }
  }

  String? validateUsername(String? username) {
    if (username == null || username.trim().isEmpty) {
      return 'Username is required';
    }
    if (username.trim().length < 3) {
      return 'At least 3 characters required';
    }
    return null;
  }

  String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: ColorTheme.textPrimary),
      ),
      backgroundColor: ColorTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === Header ===
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: ColorTheme.textPrimary,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign up to get started today.',
                  style: TextStyle(
                    fontSize: 15,
                    color: ColorTheme.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 40),

                // === Username field ===
                FormLabel(label: "Username"),
                const SizedBox(height: 8),
                StringInput(
                  controller: _usernameController,
                  validator: validateUsername,
                  hint: "e.g. JohnDoe",
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 20),

                // === Email field ===
                FormLabel(label: "Email"),
                const SizedBox(height: 8),
                EmailInput(
                  hint: "abc@gmail.com",
                  controller: _emailController,
                  validator: validateEmail,
                ),
                const SizedBox(height: 20),

                // === Password ===
                FormLabel(label: "Password"),
                const SizedBox(height: 8),
                PasswordInput(
                  controller: _passwordController,
                  validator: validatePassword,
                ),
                const SizedBox(height: 36),

                // === Register button ===
                FullWidthApiCallButton(
                  textButton: "Create account",
                  isLoading: _isLoading,
                  onPress: _onRegister,
                ),
                const SizedBox(height: 18),

                // === Footer ===
                AuthFormFooter(
                  text: "Already have an account?",
                  url: "/auth/login",
                  urlText: "Login",
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
