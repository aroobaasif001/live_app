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

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.isPassword = false,
    this.obscureText = false,
    this.validator, this.suffixIcon,this.prefixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none, // ✅ No visible borders
          hintText: hintText,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey, // ✅ Matches label color
            fontSize: 16,
          ),
          suffixIcon: suffixIcon, // ✅ No suffix icon for non-password fields
          prefixIcon: prefixIcon, // ✅ No suffix icon for non-password fields
        ),
      ),
    );
  }
}
