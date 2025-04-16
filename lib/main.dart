import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:live_app/view/homeScreen/bottomNaviagtionBar/bottom_nav_bar.dart';
import 'package:live_app/view/auth/socials_login_screen.dart';
import 'package:live_app/view/market/tabs/payment_screen.dart';
import 'package:live_app/view/market/tabs/product_detail/tabs/bid_screen.dart';
import 'firebase_options.dart';
import 'translate/translations_app.dart';
import 'utils/store_services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:device_preview/device_preview.dart';
import 'package:live_app/translate/controller/translations_controller.dart';

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

    debugPrint("  Firebase initialized successfully.");
  } catch (e) {
    debugPrint("  Firebase Initialization Error: $e");
  }

  Get.put(TranslationsController());

  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(isLoggedIn: isLoggedIn),
  ));
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
          home: FutureBuilder(
            future: _checkIfUserIsBlocked(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return SocialsLoginScreen(); // Handle any error scenario
              } else if (snapshot.hasData && snapshot.data == true) {
                return BlockedScreen(); // If blocked, navigate to BlockedScreen
              } else {
                return (isLoggedIn ?? false)
                    // ? BottomNavigationBarWidget()
              ? BidScreen()
                    : SocialsLoginScreen();
              }
            },
          ),
          translations: TranslationsApp(),
          locale: Get.deviceLocale ?? const Locale('en'),
          fallbackLocale: const Locale('en'),
        );
      },
    );
  }

  Future<bool> _checkIfUserIsBlocked() async {
    if (isLoggedIn == true) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('UserEntity')
            .doc(FirebaseAuth
                .instance.currentUser!.uid) // Get the current user's UID
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data();
          bool isBlocked = userData?['isBlocked'] ?? false;
          return isBlocked;
        }
      } catch (e) {
        debugPrint("Error checking user blocked status: $e");
      }
    }
    return false; // Default to not blocked if no data or error occurs
  }
}

// Blocked Screen: If the user is blocked, they will be shown this screen
class BlockedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blocked'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.block,
              size: 80,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'Your account has been blocked by the admin.',
              style: TextStyle(fontSize: 20, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Please contact support for more details.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Close the app or navigate elsewhere
                SystemNavigator.pop();
              },
              child: Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}
