import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_app/custom_widgets/custom_background_scaffold.dart';
import 'package:live_app/custom_widgets/custom_icon_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/icons_path.dart';
import 'package:live_app/utils/images_path.dart';
import 'package:live_app/view/auth/login_screen.dart';
import 'package:live_app/view/auth/registration_screen.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SocialsLoginScreen extends StatelessWidget {
  const SocialsLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomBackgroundScaffold(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  /// Register
                  GestureDetector(
                    onTap: () {
                      Get.to(() => RegistrationScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GradientText(
                          'Register',
                          colors: [purpleColor, pinkColor],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'MontserratAlternates',
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded,
                            color: Color(0xffE26ADC), size: 15),
                      ],
                    ),
                  ),

                  /// Login
                  GestureDetector(
                    onTap: () {
                      Get.to(() => LoginScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GradientText(
                          'Login',
                          colors: [purpleColor, pinkColor],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'MontserratAlternates',
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded,
                            color: Color(0xffE26ADC), size: 15),
                      ],
                    ),
                  ),

                  /// Central logo and images
                  Image(image: AssetImage(backgroundImage)),

                  /// Main text
                  const SizedBox(height: 20),
                  const CustomText(
                    text: 'Grab it!',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SFProRounded',
                  ),
                  const CustomText(
                    text:
                        'Join the online shopping community as a seller or buyer',
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    fontFamily: 'MontserratAlternates',
                  ),
                  const SizedBox(height: 20),

                  // Buttons
                  CustomIconButton(
                    onPressed: () {
                      signUpGoogle();
                    },
                    text: 'Continue with Google',
                    iconPath: googleIcon,
                  ),
                  const SizedBox(height: 10),
                  CustomIconButton(
                    onPressed: () {},
                    text: 'Continue with Apple',
                    iconPath: appleIcon,
                  ),
                  const SizedBox(height: 10),
                  CustomIconButton(
                    onPressed: () {},
                    text: 'Continue with Email',
                    iconPath: emailIcon,
                  ),
                  const SizedBox(height: 20),

                  // Terms and conditions
                  const CustomText(
                    text:
                        'By continuing, you agree to the Terms of Service and Privacy Policy',
                    textAlign: TextAlign.center,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Google Sign-Up Function
  Future<void> signUpGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        Get.snackbar(
          'Sign in',
          'Google sign-in canceled by user',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        List<String> nameParts = (user.displayName ?? "").split(" ");
        String firstName = nameParts.isNotEmpty ? nameParts[0] : "User";
        String lastName = nameParts.length > 1 ? nameParts[1] : "";


        Get.offAll(() => RegistrationScreen(
          firstName: firstName,
          lastName: lastName,
          email: user.email ?? "",
          isSignUpWithGoogle: true,
        ));

        Get.snackbar(
          'Success',
          'Google Sign-In Successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Google Sign-In failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Google Sign-In failed: $e');
    }
  }

}

