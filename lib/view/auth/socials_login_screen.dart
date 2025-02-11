import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                  /// register
                  GestureDetector(
                    onTap: () {
                      Get.to(()=> RegistrationScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GradientText(
                          'Register',
                          colors: [
                            purpleColor,
                            pinkColor
                          ],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'MontserratAlternates',
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded,color: Color(0xffE26ADC),size: 15,)
                      ],
                    ),
                  ),
                  ///login
                  GestureDetector(
                    onTap: () {
                      Get.to(()=> LoginScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GradientText(
                          'Login',
                          colors: [
                            purpleColor,
                            pinkColor
                          ],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'MontserratAlternates',
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded,color: Color(0xffE26ADC),size: 15,)
                      ],
                    ),
                  ),

                  /// Central logo and images
                  Image(image: AssetImage(backgroundImage)),
                  /// Main text
                  SizedBox(height: 20),
                  CustomText(
                    text: 'Grab it!',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SFProRounded',
                  ),
                  CustomText(
                    text: 'Join the online shopping community as a seller or buyer',
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    fontFamily: 'MontserratAlternates',
                  ),
                  SizedBox(height: 20),
                  // Buttons
                  CustomIconButton(onPressed: (){}, text: 'Continue with Apple', iconPath: appleIcon),
                  SizedBox(height: 10),
                  CustomIconButton(onPressed: (){}, text: 'Continue with Google', iconPath: googleIcon),
                  SizedBox(height: 10),
                  CustomIconButton(onPressed: (){}, text: 'Continue with Email', iconPath: emailIcon),
                  SizedBox(height: 20),
                  // Terms and conditions
                  CustomText(
                    text: 'By continuing, you agree to the Terms of Service and Privacy Policy',
                    textAlign: TextAlign.center,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}