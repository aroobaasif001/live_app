import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.isPassword = false,
    this.validator,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
        controller: widget.controller,
        obscureText: _obscureText,
        validator: widget.validator,
        decoration: InputDecoration(
          border: InputBorder.none, // ✅ No visible borders
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey, // ✅ Matches label color
            fontSize: 16,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText; // ✅ Toggle visibility
              });
            },
          )
              : null, // ✅ No suffix icon for non-password fields
        ),
      ),
    );
  }
}
