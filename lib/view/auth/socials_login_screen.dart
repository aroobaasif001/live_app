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
import 'package:live_app/view/homeScreen/bottomNaviagtionBar/bottom_nav_bar.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../utils/store_services.dart';

class SocialsLoginScreen extends StatelessWidget {
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Register
                        GestureDetector(
                          onTap: () {
                            Get.to(() => RegistrationScreen());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                              Icon(Icons.arrow_forward_ios_rounded,
                                  color: Color(0xffE26ADC), size: 15)
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
                                'login'.tr,
                                colors: [purpleColor, pinkColor],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'MontserratAlternates',
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios_rounded,
                                  color: Color(0xffE26ADC), size: 15)
                            ],
                          ),
                        ),

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
                    text: 'YourPurchaseisProtected'.tr,
                    fontSize: 28,
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
                  // CustomIconButton(
                  //   onPressed: () {
                  //     // Add Apple sign-in functionality if needed.
                  //   },
                  //   text: 'continue_with_apple'.tr,
                  //   iconPath: appleIcon,
                  // ),
                 // SizedBox(height: 10),
                  CustomIconButton(
                    onPressed: () {
                      signUpGoogle();
                    },
                    text: 'continue_with_google'.tr,
                    iconPath: googleIcon,
                  ),
                  SizedBox(height: 10),
                  CustomIconButton(
                    onPressed: () {
                      // Email sign in functionality here.
                      Get.to(()=>RegistrationScreen());
                    },
                    text: 'continue_with_email'.tr,
                    iconPath: emailIcon,
                  ),
                  SizedBox(height: 20),
                  // Terms and conditions
                  CustomText(
                    text: 'terms_conditions11'.tr,
                    textAlign: TextAlign.center,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 5),
                      const SizedBox(height: 5),
                  // GradientText(
                  //   'terms_conditions2'.tr,
                  //   textAlign: TextAlign.center,
                  //   colors: [
                  //     Color(0xff8385E6),
                  //     Color(0xffE569DB),
                  //   ],
                  // ),
                  RichText(
  textAlign: TextAlign.center,
  text: TextSpan(
    style: TextStyle(fontSize: 16.0), // Base style
    children: [
      TextSpan(
        text: 'Terms of Service ',
        style: TextStyle(
          fontSize: 14,
          foreground: Paint()
            ..shader = LinearGradient(
              colors: [Color(0xff8385E6), Color(0xffE569DB)],
            ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
        ),
      ),
      TextSpan(
        text: 'and',
        style: TextStyle(color: Colors.black,fontSize: 14),
      ),
      TextSpan(
        
        text: ' Privacy Policy.',
        style: TextStyle(
               fontSize: 14,
          foreground: Paint()
            ..shader = LinearGradient(
              colors: [Color(0xff8385E6), Color(0xffE569DB)],
            ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
        ),
      ),
    ],
  ),
)
,
                  SizedBox(height: 20),
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

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Check if the user is new or already registered
        bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? true;

        if (isNewUser) {
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
            'Google Sign-In Successful. Please complete registration.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          await StorageService.setLoggedIn(true);
          Get.offAll(() => BottomNavigationBarWidget());

          Get.snackbar(
            'Success',
            'Google Sign-In Successful.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
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




///

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:live_app/custom_widgets/custom_background_scaffold.dart';
// import 'package:live_app/custom_widgets/custom_icon_button.dart';
// import 'package:live_app/custom_widgets/custom_text.dart';
// import 'package:live_app/utils/colors.dart';
// import 'package:live_app/utils/icons_path.dart';
// import 'package:live_app/utils/images_path.dart';
// import 'package:live_app/view/auth/login_screen.dart';
// import 'package:live_app/view/auth/registration_screen.dart';
// import 'package:live_app/view/homeScreen/bottomNaviagtionBar/bottom_nav_bar.dart';
// import 'package:simple_gradient_text/simple_gradient_text.dart';
//
// import '../../utils/store_services.dart';
//
// class SocialsLoginScreen extends StatelessWidget {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: CustomBackgroundScaffold(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 28),
//               child: Column(
//                 children: [
//                   /// Register
//                   GestureDetector(
//                     onTap: () {
//                       Get.to(() => RegistrationScreen());
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         GradientText(
//                           'register'.tr,
//                           colors: [purpleColor, pinkColor],
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: 'MontserratAlternates',
//                           ),
//                         ),
//                         Icon(Icons.arrow_forward_ios_rounded, color: Color(0xffE26ADC), size: 15)
//                       ],
//                     ),
//                   ),
//                   /// Login
//                   GestureDetector(
//                     onTap: () {
//                       Get.to(() => LoginScreen());
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         GradientText(
//                           'login'.tr,
//                           colors: [purpleColor, pinkColor],
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: 'MontserratAlternates',
//                           ),
//                         ),
//                         Icon(Icons.arrow_forward_ios_rounded, color: Color(0xffE26ADC), size: 15)
//                       ],
//                     ),
//                   ),
//
//                   /// Central logo and images
//                   Image(image: AssetImage(backgroundImage)),
//                   /// Main text
//                   SizedBox(height: 20),
//                   CustomText(
//                     text: 'grab_it'.tr,
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'SFProRounded',
//                   ),
//                   CustomText(
//                     text: 'join_community'.tr,
//                     textAlign: TextAlign.center,
//                     fontSize: 16,
//                     fontFamily: 'MontserratAlternates',
//                   ),
//                   SizedBox(height: 20),
//                   // Buttons
//                   CustomIconButton(
//                     onPressed: () {
//                       // Add Apple sign-in functionality if needed.
//                     },
//                     text: 'continue_with_apple'.tr,
//                     iconPath: appleIcon,
//                   ),
//                   SizedBox(height: 10),
//                   CustomIconButton(
//                     onPressed: () {
//                       signUpGoogle();
//                     },
//                     text: 'continue_with_google'.tr,
//                     iconPath: googleIcon,
//                   ),
//                   SizedBox(height: 10),
//                   CustomIconButton(
//                     onPressed: () {
//                       // Email sign in functionality here.
//                     },
//                     text: 'continue_with_email'.tr,
//                     iconPath: emailIcon,
//                   ),
//                   SizedBox(height: 20),
//                   // Terms and conditions
//                   CustomText(
//                     text: 'terms_conditions'.tr,
//                     textAlign: TextAlign.center,
//                     fontSize: 12,
//                     color: Colors.grey,
//                   ),
//                   const SizedBox(width: 5),
//                   GradientText(
//                     'terms_conditions2'.tr,
//                     textAlign: TextAlign.center,
//                     colors: [
//                       Color(0xff8385E6),
//                       Color(0xffE569DB),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Google Sign-Up Function
//   Future<void> signUpGoogle() async {
//     try {
//       final GoogleSignIn googleSignIn = GoogleSignIn();
//       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//
//       if (googleUser == null) {
//         Get.snackbar(
//           'Sign in',
//           'Google sign-in canceled by user',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }
//
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final OAuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       UserCredential userCredential =
//       await FirebaseAuth.instance.signInWithCredential(credential);
//       User? user = userCredential.user;
//
//       if (user != null) {
//         // Check if the user is new or already registered
//         bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? true;
//
//         if (isNewUser) {
//           List<String> nameParts = (user.displayName ?? "").split(" ");
//           String firstName = nameParts.isNotEmpty ? nameParts[0] : "User";
//           String lastName = nameParts.length > 1 ? nameParts[1] : "";
//
//           Get.offAll(() => RegistrationScreen(
//             firstName: firstName,
//             lastName: lastName,
//             email: user.email ?? "",
//             isSignUpWithGoogle: true,
//           ));
//
//           Get.snackbar(
//             'Success',
//             'Google Sign-In Successful. Please complete registration.',
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//           );
//         } else {
//           await StorageService.setLoggedIn(true);
//           Get.offAll(() => BottomNavigationBarWidget());
//
//           Get.snackbar(
//             'Success',
//             'Google Sign-In Successful.',
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//           );
//         }
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Google Sign-In failed: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       print('Google Sign-In failed: $e');
//     }
//   }
// }
