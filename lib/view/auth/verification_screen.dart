import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/view/auth/notification_screen.dart';


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

        Get.snackbar("Success", "Email verified successfully!");

        // ✅ Navigate to NavigationScreen after verification
        Future.delayed(Duration(seconds: 2), () {
          Get.offAll(() => NotificationScreen()); // ✅ Replace entire stack
        });
      } else {
        Get.snackbar("Error", "Email is not verified yet.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to check verification status.");
    }

    setState(() {
      isLoading = false;
    });
  }

  /// **🔥 Resend Verification Email**
  Future<void> _resendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      Get.snackbar("Email Sent", "Check your email for the verification link.");
    } catch (e) {
      Get.snackbar("Error", "Failed to send verification email.");
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
                text: 'Email Verification',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFProRounded',
              ),
              SizedBox(height: 20),
              CustomText(
                text: 'We have sent you a verification email.',
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'MontserratAlternates',
              ),
              SizedBox(height: 50),
              // **Check Verification Button**
              CustomGradientButton(
                text: isLoading ? "Checking..." : "Verify Now",
                onPressed: isLoading ? () {} : _checkEmailVerification,
              ),
              SizedBox(height: 10),
              // **Resend Email Button**
              CustomGradientButton(
                text: "Resend Email",
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


/// ///

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:live_app/custom_widgets/custom_gradient_button.dart';
// import 'package:live_app/custom_widgets/custom_text.dart';
//
// class VerificationScreen extends StatefulWidget {
//   const VerificationScreen({super.key});
//
//   @override
//   _VerificationScreenState createState() => _VerificationScreenState();
// }
//
// class _VerificationScreenState extends State<VerificationScreen> {
//   bool isVerified = false;
//   bool isLoading = false;
//
//   /// **🔥 Check if Email is Verified**
//   Future<void> _checkEmailVerification() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       await FirebaseAuth.instance.currentUser!.reload();
//       User? user = FirebaseAuth.instance.currentUser;
//
//       if (user != null && user.emailVerified) {
//         setState(() {
//           isVerified = true;
//         });
//         Get.snackbar("Success", "Email verified successfully!");
//         // Get.to(() => HomeScreen()); // ✅ Navigate to Home if needed
//       } else {
//         Get.snackbar("Error", "Email is not verified yet.");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to check verification status.");
//     }
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   /// **🔥 Resend Verification Email**
//   Future<void> _resendVerificationEmail() async {
//     try {
//       await FirebaseAuth.instance.currentUser!.sendEmailVerification();
//       Get.snackbar("Email Sent", "Check your email for the verification link.");
//     } catch (e) {
//       Get.snackbar("Error", "Failed to send verification email.");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 28),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CustomText(
//                 text: 'Email Verification',
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'SFProRounded',
//               ),
//               SizedBox(height: 20),
//               CustomText(
//                 text: 'We have sent you a verification email.',
//                 fontSize: 14,
//                 color: Colors.grey,
//                 fontFamily: 'MontserratAlternates',
//               ),
//               SizedBox(height: 50),
//               CustomGradientButton(
//                 text: isLoading ? "Checking..." : "Verify Now",
//                 onPressed: isLoading ? () {} : _checkEmailVerification,
//               ),
//               SizedBox(height: 10),
//               CustomGradientButton(
//                 text: "Resend Email",
//                 onPressed: _resendVerificationEmail,
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//

///

// import 'package:flutter/material.dart';
// import 'package:live_app/custom_widgets/custom_container.dart';
// import 'package:live_app/custom_widgets/custom_gradient_button.dart';
// import 'package:live_app/custom_widgets/custom_text.dart';
//
// class VerificationScreen extends StatelessWidget {
//   const VerificationScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 28),
//           child: Column(
//             children: [
//               // Title
//               CustomText(
//                 text: 'Enter Code',
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'SFProRounded',
//               ),
//               SizedBox(height: 20),
//               // Code input fields
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(5, (index) {
//                   return Expanded(
//                     child: CustomContainer(
//                       width: 53,
//                       height: 68,
//                       margin: EdgeInsets.symmetric(horizontal: 4),
//                         conColor: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.shade200,
//                             blurRadius: 4,
//                             offset: Offset(2, 2),
//                           ),
//                         ],
//                       child: Center(
//                         child: CustomText(
//                           text: '0',
//                           fontSize: 20,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//               SizedBox(height: 20),
//               // Message
//               CustomText(
//                 text: 'We have sent you a code via email',
//                 fontSize: 14,
//                 color: Colors.grey,
//                 fontFamily: 'MontserratAlternates',
//               ),
//               Spacer(),
//               // Login button
//               CustomGradientButton(
//                 text: 'Login', onPressed: () {
//               },),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }