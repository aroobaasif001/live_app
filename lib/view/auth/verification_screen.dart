import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/view/auth/notification_screen.dart';

import '../homeScreen/bottomNaviagtionBar/bottom_nav_bar.dart';


class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool isVerified = false;
  bool isLoading = false;

  /// **🔥 Check if Email is Verified**
  Future<void> _checkEmailVerification() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.currentUser!.reload();
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        setState(() {
          isVerified = true;
        });

        Get.snackbar("Success", "email_verified".tr);

        // ✅ Navigate to NavigationScreen after verification
        Future.delayed(Duration(seconds: 2), () {
          Get.offAll(() => BottomNavigationBarWidget()); // ✅ Replace entire stack
        });
      } else {
        Get.snackbar("Error", "email_not_verified".tr);
      }
    } catch (e) {
      Get.snackbar("Error", "verification_check_failed".tr);
    }

    setState(() {
      isLoading = false;
    });
  }

  /// **🔥 Resend Verification Email**
  Future<void> _resendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      Get.snackbar("Success", "email_sent".tr);
    } catch (e) {
      Get.snackbar("Error", "email_send_failed".tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: 'email_verification'.tr,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFProRounded',
              ),
              SizedBox(height: 20),
              CustomText(
                text: 'verification_sent'.tr,
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'MontserratAlternates',
              ),
              SizedBox(height: 50),
              // **Check Verification Button**
              CustomGradientButton(
                text: isLoading ? "checking".tr : "verify_now".tr,
                onPressed: isLoading ? null : _checkEmailVerification,
              ),
              SizedBox(height: 10),
              // **Resend Email Button**
              CustomGradientButton(
                text: "resend_email".tr,
                onPressed: _resendVerificationEmail,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
