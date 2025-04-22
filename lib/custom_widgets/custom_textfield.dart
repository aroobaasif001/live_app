// import 'package:flutter/material.dart';

// class CustomTextField extends StatelessWidget {
//   final String hintText;
//   final TextEditingController? controller;
//   final bool isPassword;
//   final bool obscureText;
//   final String? Function(String?)? validator;
//   final Widget? suffixIcon;
//   final Widget? prefixIcon;
//   final TextInputType? keyboardType;
//   final Function(String)? onChanged;
//    final bool isRequired; // Added onChanged callback

//   const CustomTextField({
//     super.key,
//     required this.hintText,
//     this.controller,
//     this.isPassword = false,
//     this.obscureText = false,
//     this.validator,
//     this.suffixIcon,
//     this.prefixIcon,
//     this.keyboardType,
//     this.onChanged,
//       this.isRequired = false,  // Added onChanged to constructor
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       validator: validator,
//       keyboardType: keyboardType,
//       onChanged: onChanged, // Added onChanged event
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.white, // Background color
//         contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10), // Rounded corners
//           borderSide: BorderSide.none, // No visible border
//         ),
//         //hintText: hintText,
//         // hintText: isRequired ? '$hintText*' : hintText,
//         // hintStyle: const TextStyle(
//         //   fontWeight: FontWeight.bold,
//         //   color: Colors.grey,
//         //   fontSize: 16,
//         // ),
//             hintText: isRequired ? null : hintText, // Show hint only for non-required
//         hintStyle: const TextStyle(
//           fontWeight: FontWeight.bold,
//           color: Colors.grey,
//           fontSize: 16,
//         ),
//         label: isRequired 
//             ? RichText(
//                 text: TextSpan(
//                   text: hintText,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey,
//                     fontSize: 16,
//                   ),
//                   children: const [
//                     TextSpan(
//                       text: ' *',
//                       style: TextStyle(
//                         color: Colors.red,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : null,
//         suffixIcon: suffixIcon,
//         prefixIcon: prefixIcon,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final AutovalidateMode? autovalidateMode;
  final TextEditingController? controller;
  final bool isPassword;
  final bool obscureText;
  final bool isRequired;
  final bool readOnly;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.autovalidateMode,
    this.controller,
    this.isPassword = false,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.onChanged,
    this.isRequired = false,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      validator: validator,
      autovalidateMode: autovalidateMode,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintText: isRequired ? null : hintText,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          fontSize: 16,
        ),
        label: isRequired
            ? Text.rich(
                TextSpan(
                  text: hintText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  children: const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              )
            : null,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        errorStyle: const TextStyle(
          color: Colors.redAccent,
          fontSize: 13,
        ),
      ),
    );
  }
}

