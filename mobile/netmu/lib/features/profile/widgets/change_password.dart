import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/core/widgets/button.dart';
import 'package:netmu/core/widgets/error_message.dart';
import 'package:netmu/core/widgets/form_label.dart';
import 'package:netmu/core/widgets/input.dart';
import 'package:netmu/features/profile/models/profile_dto.dart';
import 'package:netmu/features/profile/services/profile_service.dart';

class ChangePassword extends StatefulWidget {
  final ProfileService _service = ProfileService();
  ChangePassword({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordState();
  }
}

class _ChangePasswordState extends State<ChangePassword> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  bool _isLoading = false;

  void _onChangePassword() async {
    if (_key.currentState!.validate()) {
      // Set loading state
      setState(() => _isLoading = true);

      // Make request
      final req = ChangePasswordRequest(
        oldPassword: _oldPassController.text,
        newPassword: _newPassController.text,
      );
      var (success, message) = await widget._service.changePassword(req);

      if (mounted) {
        if (!success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(ErrorMessage(textContent: message));
          return;
        }
        Navigator.pop(context);
      }
    }
  }

  String? validateConfirmPassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return password == _newPassController.text
        ? null
        : "Confirm password must match new password";
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
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === Old password field ===
                FormLabel(label: "Old password"),
                const SizedBox(height: 8),
                PasswordInput(
                  controller: _oldPassController,
                  validator: validatePassword,
                ),
                const SizedBox(height: 20),

                // === New password field ===
                FormLabel(label: "New password"),
                const SizedBox(height: 8),
                PasswordInput(
                  controller: _newPassController,
                  validator: validatePassword,
                ),
                const SizedBox(height: 20),

                // === Confirm password field ===
                FormLabel(label: "Confirm password"),
                const SizedBox(height: 8),
                PasswordInput(
                  controller: _confirmPassController,
                  validator: validateConfirmPassword,
                ),
                const SizedBox(height: 20),

                // === Update profile button ===
                FullWidthApiCallButton(
                  textButton: "Change password",
                  isLoading: _isLoading,
                  onPress: _onChangePassword,
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
