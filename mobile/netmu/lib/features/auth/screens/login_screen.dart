import "package:flutter/material.dart";
import "package:netmu/core/themes/theme.dart";
import "package:netmu/core/utils/logger/logger.dart";
import "package:netmu/features/auth/models/login_dto.dart";
import "package:netmu/features/auth/services/auth_service.dart";
import "package:netmu/features/auth/widgets/auth_form_footer.dart";
import "package:netmu/core/widgets/button.dart";
import "package:netmu/core/widgets/input.dart";
import "package:netmu/core/widgets/form_label.dart";



class LoginScreen extends StatefulWidget {
  final AuthService _service = AuthService();

  LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (_formKey.currentState!.validate()) {
      // Set loading state
      setState(() => _isLoading = true);

      // Make request
      final username = _usernameController.text;
      final password = _passwordController.text;
      final request = LoginRequest(username: username, password: password);
      var success = await widget._service.login(request);

      // Whether request failed or not, we both set loading state to false
      setState(() => _isLoading = false);

      // Check if success or not
      if (mounted) {
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(child: Text("Failed to login")),
                backgroundColor: Colors.red,
              )
          );

          NetmuLog.logger.w("Failed to register");
          return;
        }

        // If success, redirect to login
        Navigator.pushNamed(context, "/main");
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
                  'Login',
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
                  'Welcome back.',
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

                // === Password ===
                FormLabel(label: "Password"),
                const SizedBox(height: 8),
                PasswordInput(
                  controller: _passwordController,
                  validator: validatePassword,
                ),
                const SizedBox(height: 36),

                // === Login button ===
                FullWidthApiCallButton(
                  textButton: "Login",
                  isLoading: _isLoading,
                  onPress: _onLogin,
                ),
                SizedBox(height: 18),

                // === Footer ===
                AuthFormFooter(
                  text: "Do not have an account?",
                  url: "/auth/register",
                  urlText: "Create account",
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
