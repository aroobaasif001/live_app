import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_app/translate/controller/translations_controller.dart';
import 'package:live_app/utils/store_services.dart';
import 'package:live_app/view/auth/socials_login_screen.dart';
import 'package:live_app/view/homeScreen/bottomNaviagtionBar/bottom_nav_bar.dart';
import 'firebase_options.dart';
import 'translate/translations_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await StorageService.isLoggedIn();

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

  Get.put(TranslationsController());

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool? isLoggedIn;

  const MyApp({super.key, this.isLoggedIn});

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
          home: (isLoggedIn ?? false)
              ? BottomNavigationBarWidget()
              : SocialsLoginScreen(),
          translations: TranslationsApp(),
          locale: Get.deviceLocale ?? const Locale('en'),
          fallbackLocale: const Locale('en'),
        );
      },
    );
  }
}
