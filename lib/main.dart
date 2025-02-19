import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_app/translate/controller/translations_controller.dart';
import 'package:live_app/view/auth/login_screen.dart';
import 'package:live_app/view/auth/socials_login_screen.dart';
import 'package:live_app/view/homeScreen/bottomNaviagtionBar/bottom_nav_bar.dart';
import 'firebase_options.dart';
import 'translate/translations_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Load SharedPreferences before running the app
  final prefs = await SharedPreferences.getInstance();

  // Initialize GetX controller
  Get.put(TranslationsController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Live App',
          home: SocialsLoginScreen(),
          translations: TranslationsApp(),
          locale: Get.deviceLocale ?? const Locale('en'), 
          fallbackLocale: const Locale('en'),
        );
      },
    );
  }
}