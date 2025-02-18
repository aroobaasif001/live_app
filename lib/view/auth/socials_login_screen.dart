import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_background_scaffold.dart';
import 'package:live_app/custom_widgets/custom_icon_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/translate/controller/translations_controller.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/icons_path.dart';
import 'package:live_app/utils/images_path.dart';
import 'package:live_app/view/auth/login_screen.dart';
import 'package:live_app/view/auth/registration_screen.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SocialsLoginScreen extends StatelessWidget {
  final TranslationsController translationController = Get.find<TranslationsController>();

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
                  // Language Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => TextButton(
                        onPressed: () => translationController.updateLanguage('en'),
                        child: Text(
                          'English',
                          style: TextStyle(
                            color: translationController.selectedLanguage.value == 'English'
                                ? purpleColor
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                      Text(' | '),
                      Obx(() => TextButton(
                        onPressed: () => translationController.updateLanguage('ru'),
                        child: Text(
                          'Russian',
                          style: TextStyle(
                            color: translationController.selectedLanguage.value == 'Russian'
                                ? purpleColor
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                    ],
                  ),
                  /// register
                  GestureDetector(
                    onTap: () {
                      Get.to(() => RegistrationScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GradientText(
                          'register'.tr,
                          colors: [purpleColor, pinkColor],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'MontserratAlternates',
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xffE26ADC),
                          size: 15,
                        )
                      ],
                    ),
                  ),
                  ///login
                  GestureDetector(
                    onTap: () {
                      Get.to(() => LoginScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GradientText(
                          'login'.tr,
                          colors: [purpleColor, pinkColor],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'MontserratAlternates',
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xffE26ADC),
                          size: 15,
                        )
                      ],
                    ),
                  ),

                  /// Central logo and images
                  Image(image: AssetImage(backgroundImage)),
                  /// Main text
                  SizedBox(height: 20),
                  CustomText(
                    text: 'grab_it'.tr,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SFProRounded',
                  ),
                  CustomText(
                    text: 'join_community'.tr,
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    fontFamily: 'MontserratAlternates',
                  ),
                  SizedBox(height: 20),
                  // Buttons
                  CustomIconButton(
                    onPressed: () {},
                    text: 'continue_with_apple'.tr,
                    iconPath: appleIcon
                  ),
                  SizedBox(height: 10),
                  CustomIconButton(
                    onPressed: () {},
                    text: 'continue_with_google'.tr,
                    iconPath: googleIcon
                  ),
                  SizedBox(height: 10),
                  CustomIconButton(
                    onPressed: () {},
                    text: 'continue_with_email'.tr,
                    iconPath: emailIcon
                  ),
                  SizedBox(height: 20),
                  // Terms and conditions
                  CustomText(
                    text: 'terms_conditions'.tr,
                    textAlign: TextAlign.center,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 5),
                  GradientText(
                    'terms_conditions2'.tr,
                    textAlign: TextAlign.center,
                    colors: [
                      Color(0xff8385E6),
                      Color(0xffE569DB),
                    ],
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