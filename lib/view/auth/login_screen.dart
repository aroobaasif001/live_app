import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/custom_widgets/custom_textfield.dart';
import 'package:live_app/view/auth/verification_screen.dart';
import 'package:live_app/view/homeScreen/bottomNaviagtionBar/bottom_nav_bar.dart';

import '../../utils/store_services.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  /// **🔥 Firebase Login Function**
  Future<void> _loginUser() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Get.snackbar("Error", "fill_all_fields".tr);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance
          .setLanguageCode(Get.locale?.languageCode ?? "en");
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Get.snackbar("Success", "login_successful".tr);
      await StorageService.setLoggedIn(true);
      Get.to(() => BottomNavigationBarWidget());
    } on FirebaseAuthException catch (e) {
      String errorMessage = "login_failed".tr;
      if (e.code == 'user-not-found') {
        errorMessage = "user_not_found".tr;
      } else if (e.code == 'wrong-password') {
        errorMessage = "wrong_password".tr;
      }
      Get.snackbar("Error", errorMessage);
    }

    setState(() {
      isLoading = false;
    });
  }
bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Get.back(),
                  tooltip: 'close'.tr,
                ),
              ),
              SizedBox(height: 20),
              CustomText(
                
                text: 'login'.tr,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFProRounded',
              ),
              SizedBox(height: 20),
              CustomTextField(
                hintText: 'email'.tr,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter_email'.tr;
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                      .hasMatch(value)) {
                    return 'invalid_email'.tr;
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomTextField(
                suffixIcon: IconButton(   onPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },icon:     Icon(
        _obscurePassword ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey,
      ),),
                hintText: 'password'.tr,
                controller: _passwordController,
                obscureText:_obscurePassword ,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter_password'.tr;
                  }
                  if (value.length < 6) {
                    return 'password_length'.tr;
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // CustomGradientButton(
              //   text: isLoading ? 'logging_in'.tr : 'get_code'.tr,
              //   onPressed: isLoading ? null : _loginUser,
              // ),
              CustomGradientButton(
                text: 'login'.tr,
                onPressed: isLoading ? null : _loginUser,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:live_app/custom_widgets/custom_gradient_button.dart';
// import 'package:live_app/custom_widgets/custom_text.dart';
// import 'package:live_app/custom_widgets/custom_textfield.dart';
// import 'package:live_app/view/auth/verification_screen.dart';
//
// class LoginScreen extends StatelessWidget {
//   LoginScreen({super.key});
//
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 28),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Close button
//               Align(
//                 alignment: Alignment.topRight,
//                 child: IconButton(
//                   icon: Icon(Icons.close),
//                   onPressed: () {
//                     Get.back();
//                   },
//                 ),
//               ),
//               SizedBox(height: 20),
//               // Title
//               CustomText(
//                 text: 'Login',
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'SFProRounded',
//               ),
//               SizedBox(height: 20),
//               // Email field
//               CustomTextField(
//                 hintText: 'Email',
//                 controller: _emailController,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   if (!RegExp(
//                           r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
//                       .hasMatch(value)) {
//                     return 'Enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               CustomTextField(
//                 hintText: 'Password',
//                 controller: _passwordController,
//                 isPassword: true, // ✅ Enables visibility toggle
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your password';
//                   }
//                   if (value.length < 6) {
//                     return 'Password must be at least 6 characters';
//                   }
//                   return null;
//                 },
//               ),
//
//               SizedBox(height: 20),
//               // Login button
//               CustomGradientButton(
//                 text: 'Get Code',
//                 onPressed: () {
//                   Get.to(() => VerificationScreen());
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
