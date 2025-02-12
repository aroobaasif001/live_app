import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/view/auth/socials_login_screen.dart';
import 'package:live_app/view/market/market_screen.dart';
import 'package:live_app/view/profile_views/profile_screen.dart';
import 'firebase_options.dart';
import 'view/homeScreen/homeMainScreen/home_main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.deviceCheck,
      webProvider: ReCaptchaV3Provider('PASTE_YOUR_RECAPTCHA_SITE_KEY_HERE'),
    );

    debugPrint("🔥 Firebase initialized successfully.");
  } catch (e) {
    debugPrint("🔥 Firebase Initialization Error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Live App",
      home: const ProfileScreen(),
    );
  }
}

