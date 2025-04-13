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
  bool isLoading = false;

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.setLanguageCode(Get.locale?.languageCode ?? "en");
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      Get.snackbar("Success", "Password reset email sent!");
      Get.back();
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with that email";
      }
      Get.snackbar("Error", errorMessage);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Get.back(),
                  tooltip: 'close'.tr,
                ),
              ),
              SizedBox(height: 20),
              // Title
              CustomText(
                text: 'Reset Password',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFProRounded',
              ),
              SizedBox(height: 20),

              // Email field
              CustomTextField(
                hintText: 'Enter your email',
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                      .hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              CustomGradientButton(
                text: isLoading ? 'Sending...' : 'Send Reset Link',
                onPressed: isLoading ? null : _resetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
