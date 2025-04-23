import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/custom_widgets/custom_textfield.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim().toLowerCase();

    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.setLanguageCode(Get.locale?.languageCode ?? "en");

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      setState(() => isLoading = false);

      Get.defaultDialog(
        title: "Email Sent",
        middleText: "A password reset link has been sent to $email.",
        confirm: TextButton(
          onPressed: () {
            Get.back(); // Close dialog
            Get.back(); // Go back to login screen
          },
          child: Text("OK"),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);

      String errorMessage = "Something went wrong";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email format.";
      }

      Get.snackbar(
        "Error",
        errorMessage,
        backgroundColor: Colors.white,
        colorText: Colors.red,
        icon: Icon(Icons.error_outline, color: Colors.red),
      );
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar(
        "Error",
        "Unexpected error occurred. Please try again.",
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Get.back(),
                    tooltip: 'Close',
                  ),
                ),
                SizedBox(height: 20),
                CustomText(
                  text: 'Reset Password',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SFProRounded',
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Email *',
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                        .hasMatch(value.trim())) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                CustomGradientButton(
                  text: isLoading ? 'Sending...' : 'Send Reset Link',
                  onPressed: isLoading ? null : _resetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


