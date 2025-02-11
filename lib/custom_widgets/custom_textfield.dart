import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Widget? suffixIcon;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.suffixIcon, this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // ✅ Rounded edges
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // ✅ Soft shadow effect
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none, // ✅ No visible borders
          hintText: hintText,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey, // ✅ Matches label color
            fontSize: 16,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
