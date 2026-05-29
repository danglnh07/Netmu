import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/core/widgets/button.dart';
import 'package:netmu/core/widgets/error_message.dart';
import 'package:netmu/core/widgets/form_label.dart';
import 'package:netmu/core/widgets/input.dart';
import 'package:netmu/features/profile/models/profile_dto.dart';
import 'package:netmu/features/profile/services/profile_service.dart';

class UpdateProfile extends StatefulWidget {
  final _service = ProfileService();
  final String username;
  final String email;
  final VoidCallback onUpdate;
  UpdateProfile({
    super.key,
    required this.username,
    required this.email,
    required this.onUpdate,
  });

  @override
  State<StatefulWidget> createState() {
    return _UpdateProfileState();
  }
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
  }

  void _onUpdateProfile() async {
    if (_key.currentState!.validate()) {
      // Set loading state
      setState(() => _isLoading = true);

      // Make request
      final req = UpdateUserProfile(
        username: _usernameController.text,
        email: _emailController.text,
      );
      var (success, message) = await widget._service.updateProfile(req);

      if (mounted) {
        if (!success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(ErrorMessage(textContent: message));
          return;
        }

        widget.onUpdate();
        Navigator.pop(context);
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
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                // === Update profile button ===
                FullWidthApiCallButton(
                  textButton: "Update profile",
                  isLoading: _isLoading,
                  onPress: _onUpdateProfile,
                ),
                SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
