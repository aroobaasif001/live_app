import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/custom_widgets/custom_textfield.dart';
import 'package:live_app/utils/icons_path.dart';
import 'package:live_app/view/auth/verification_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              SizedBox(height: 20),
              // Title
              CustomText(
                text: 'Login',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFProRounded',
              ),
              SizedBox(height: 20),
              // Email field
              CustomTextField(hintText: 'Email'),
              SizedBox(height: 20),
              // Password field
              CustomTextField(
                hintText: 'Password',
                suffixIcon: CustomContainer(
                  height: 18,
                  width: 18,
                  image: DecorationImage(image: AssetImage(eyeCloseIcon),scale: 3),
                ),
              ),
              SizedBox(height: 20),
              // Login button
              CustomGradientButton(
                text: 'Get Code',
                onPressed: () {
                  Get.to(()=> VerificationScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
