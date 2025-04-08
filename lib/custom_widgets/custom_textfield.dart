import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final Function(String)? onChanged; // Added onChanged callback

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.isPassword = false,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.onChanged, // Added onChanged to constructor
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      onChanged: onChanged, // Added onChanged event
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white, // Background color
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
          borderSide: BorderSide.none, // No visible border
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          fontSize: 16,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
