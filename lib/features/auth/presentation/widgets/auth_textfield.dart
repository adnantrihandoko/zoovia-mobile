import 'package:flutter/material.dart';
import 'package:puskeswan_app/components/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool? passwordVisible;
  final VoidCallback? onPasswordToggle;
  final bool enabled;

  const AuthTextField({
    super.key, 
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.isPassword = false,
    this.passwordVisible,
    this.onPasswordToggle,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          textCapitalization: TextCapitalization.none,
          maxLines: 1,
          obscureText: isPassword ? !(passwordVisible ?? false) : false,
          decoration: _buildInputDecoration(hint),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.white,
      border: _buildBorder(),
      enabledBorder: _buildBorder(Colors.grey[300]!),
      focusedBorder: _buildBorder(AppColors.primary500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: isPassword ? _buildPasswordSuffixIcon() : null,
    );
  }

  OutlineInputBorder _buildBorder([Color? color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: color != null ? BorderSide(color: color, width: 1) : BorderSide.none,
    );
  }

  Widget? _buildPasswordSuffixIcon() {
    if (!isPassword || onPasswordToggle == null) return null;
    
    return IconButton(
      icon: Icon(
        (passwordVisible ?? false) ? Icons.visibility : Icons.visibility_off,
        color: AppColors.primary500,
      ),
      onPressed: onPasswordToggle,
    );
  }
}