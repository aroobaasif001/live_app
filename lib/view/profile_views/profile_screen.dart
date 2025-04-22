import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_profile_background_scaffold.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/entities/registration_entity.dart';
import 'package:live_app/services/send_notification_service.dart';
import 'package:live_app/translate/controller/translations_controller.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/view/auth/delivery_address_screen.dart';
import 'package:live_app/view/auth/notification_screen.dart';
import 'package:live_app/view/auth/socials_login_screen.dart';
import 'package:live_app/view/homeScreen/paymentMethodScreen/reward_screen.dart';
import 'package:live_app/view/market/tabs/payment_screen.dart';
import 'package:live_app/view/profile_views/my_rewards_screen.dart';
import 'package:live_app/view/profile_views/settings_screen.dart';
import 'package:live_app/view/profile_views/sold_products_screen.dart';
import 'package:live_app/view/profile_views/trade_profile_screen.dart';
import '../../utils/icons_path.dart';
import '../../utils/images_path.dart';
import '../../utils/store_services.dart';
import '../livestreaming/live_preview.dart';
import '../livestreaming/live_streaming.dart';
import '../livestreaming/livestreamingview_screen.dart';
import 'notifications_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userId;
  int? uid;
  String? ChannelId;
  final TextEditingController _titleController = TextEditingController();

  Stream<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserData =
      FirebaseFirestore.instance
          .collection('UserEntity')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots();

  @override
  void initState() {
    uid = 10000 + Random().nextInt(90000); // Generates a 5-digit number
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    ChannelId =
        List.generate(5, (index) => chars[Random().nextInt(chars.length)])
            .join();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> settingsOptions = [
      {
        "icon": 'assets/icons/Card.png',
        "title": "payment_delivery".tr,
        "screen": PaymentScreen()
      },
      {
        "icon": 'assets/icons/Map Point.png',
        "title": "addresses".tr,
        "screen": DeliveryAddressScreen()
      },
      {
        "icon": 'assets/icons/Bell.png',
        "title": "notifications".tr,
        "screen": NotificationSettingsScreen()
      },
      {
        "icon": 'assets/icons/Letter.png',
        "title": "change_email".tr,
        "screen": SettingsScreen()
      },
      {
        "icon": 'assets/icons/Password Minimalistic Input.png',
        "title": "change_password".tr,
        "screen": SettingsScreen()
      },
      {
        "icon": 'assets/icons/Settings.png',
        "title": "settings".tr,
        "screen": SettingsScreen()
      },
    ];
    final List<Map<String, dynamic>> helpAndContact = [
      {
        "icon": 'assets/icons/Letter Opened.png',
        "title": "contact_us".tr,
        "screen": SettingsScreen()
      },
      {
        "icon": 'assets/icons/Danger Triangle.png',
        "title": "report_abuse".tr,
        "screen": SettingsScreen()
      },
      {
        "icon": 'assets/icons/Archive Check.png',
        "title": "sales_tax".tr,
        "screen": NotificationScreen()
      },
      {
        "icon": 'assets/icons/Info Circle.png',
        "title": "privacy_policy".tr,
        "screen": SettingsScreen()
      },
      {
        "icon": 'assets/icons/File.png',
        "title": "terms_conditions".tr,
        "screen": SettingsScreen()
      },
    ];
    final TranslationsController translationController =
        Get.find<TranslationsController>();

    return CustomProfileBackgroundScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StreamBuilder(
          stream: getCurrentUserData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              );
            }
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Obx(() => TextButton(
                      //           onPressed: () =>
                      //               translationController.updateLanguage('en'),
                      //           child: Text(
                      //             'English',
                      //             style: TextStyle(
                      //               color: translationController
                      //                           .selectedLanguage.value ==
                      //                       'English'
                      //                   ? purpleColor
                      //                   : Colors.grey,
                      //               fontWeight: FontWeight.bold,
                      //             ),
                      //           ),
                      //         )),
                      //     Text(' | '),
                      //     Obx(() => TextButton(
                      //           onPressed: () =>
                      //               translationController.updateLanguage('ru'),
                      //           child: Text(
                      //             'Russian',
                      //             style: TextStyle(
                      //               color: translationController
                      //                           .selectedLanguage.value ==
                      //                       'Russian'
                      //                   ? purpleColor
                      //                   : Colors.grey,
                      //               fontWeight: FontWeight.bold,
                      //             ),
                      //           ),
                      //         )),
                      //   ],
                      // ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(profileImage),
                                    fit: BoxFit.fill)),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                fontFamily: "SF Pro Rounded",
                                text: (snapshot.data!.data()?['firstName'] ?? 'User').toString(),
                                 // snapshot.data!.data()!.firstName.toString(),
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              CustomGradientButton(
                                fontSize: 13,
                                height: 30,
                                borderRadius: 30,
                                width: 130,
                                text: "trade_profile".tr,
                                onPressed: () {
                                  Get.to(() => TradeProfileScreen(
                                        userId: FirebaseAuth
                                            .instance.currentUser!.uid,
                                      ));
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final userData = snapshot.data!.data()!;
                          final userName = userData['firstName'] ?? 'User';
                          final fcmToken = userData['fcmToken'] ?? '';

                          await SendNotificationService
                              .sendToAllUserEntityTokens(
                               //  token: fcmToken,
                                  title: '📢 $userName is Live!',
                                  body: 'Join the live stream now.',

                                  
                                  data: {});
                          String title = _titleController.text.trim();

                          if (title.isEmpty) {
                            // If title is empty, set a default title.
                            title = 'Live Streaming';
                          }

                          // Store live stream details in Firebase Firestore
                          try {
                            final liveStreamData = {
                              "title": title,
                              "adminName":userName,
                                  //snapshot.data!.data()!.firstName.toString(),
                              "adminPhoto":
                                  'https://images.unsplash.com/photo-1541516160071-4bb0c5af65ba?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dGFraW5nJTIwcGhvdG98ZW58MHx8MHx8fDA%3D',
                              "adminUid": uid,
                              "isAdmin": true,
                              "channelId": ChannelId,
                              'viewsCount': 0,
                              'currentmusic': null,
                              'currentFilter': null,
                              'currentmusic_id': null,
                              'heartbeat': null,
                              "timestamp": FieldValue.serverTimestamp(),
                            };

                            await FirebaseFirestore.instance
                                .collection('livestreams')
                                .doc(ChannelId)
                                .set(liveStreamData);

                            // Navigate to LiveStreamingScreen
                            // _cameraController?.dispose();
                            // _titleController.dispose();
                            Get.to(() => LiveStreamingScreen(
                                  channelId: ChannelId ?? '',
                                  isAdmin: true,
                                  uid: uid ?? 0,
                                ));
                          } catch (e) {
                            Get.snackbar(
                              "error".tr,
                              "live_stream_error".tr,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: Container(
                          height: 155,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(profileAdvertisementImage),
                                  fit: BoxFit.cover)),
                        ),
                      ),

                      CustomText(
                        text: "account".tr,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),

                      SizedBox(
                        height: 12,
                      ),
                      // CustomGradientButton(
                      //   text: "Sold Products",
                      //   onPressed: () {
                      //     Get.to(()=>SoldProductsScreen());
                      //   },

                      Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.2))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      userGroupIcon,
                                      height: 25,
                                      width: 25,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    FittedBox(
                                      child: CustomText(
                                        text: "referrals_points".tr,
                                        fontFamily: "SF Pro Rounded",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    CustomText(
                                      text: "balance".tr,
                                      fontFamily: "Gilroy-Bold",
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => MyRewardsScreen());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        crownIcon,
                                        height: 25,
                                        width: 25,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      FittedBox(
                                        child: CustomText(
                                          text: "my_award".tr,
                                          fontFamily: "SF Pro Rounded",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      CustomText(
                                        text: "view_coupons".tr,
                                        fontFamily: "Gilroy-Bold",
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: settingsOptions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                color: Color(0xff000000).withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomContainer(
                                    height: 24,
                                    width: 24,
                                    image: DecorationImage(
                                      image: AssetImage(
                                          settingsOptions[index]['icon']),
                                    ),
                                  )),
                            ),
                            title: Text(
                              settingsOptions[index]['title'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Gilroy-Bold",
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Colors.black,
                              size: 28,
                            ),
                            onTap: () {
                              Get.to(settingsOptions[index]['screen']);
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 3,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CustomText(
                        text: "help_contacts".tr,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        fontFamily: "SF Pro Rounded",
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: helpAndContact.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                color: Color(0xff000000).withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomContainer(
                                    height: 24,
                                    width: 24,
                                    image: DecorationImage(
                                      image: AssetImage(
                                          helpAndContact[index]['icon']),
                                    ),
                                  )),
                            ),
                            title: Text(
                              helpAndContact[index]['title'],
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Gilroy-Bold",
                                  color: Color(0xff2A2A2A)),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Colors.black,
                              size: 28,
                            ),
                            onTap: () {
                              // Handle tap actions here
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          _showLogoutDialog();
                        },
                        child: CustomContainer(
                          height: 40,
                          width: double.infinity,
                          borderRadius: BorderRadius.circular(10),
                          conColor: Color(0xffE2E2E2),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomContainer(
                                height: 18,
                                width: 18,
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/icons/Arrows ALogout 2.png')),
                              ),
                              SizedBox(width: 6),
                              CustomText(
                                text: "logout".tr,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                fontFamily: "Gilroy-Bold",
                              ),
                            ],
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: primaryGradientColor),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 60,
                color: Colors.white,
              ),
              SizedBox(height: 15),
              Text(
                "confirm_logout".tr,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "logout_confirmation".tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // Close dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "cancel".tr,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Logout Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await StorageService.logout();
                        await FirebaseAuth.instance.signOut();
                        Get.back(); // Close dialog
                        Get.offAll(() =>
                            SocialsLoginScreen()); // Navigate to login screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "logout".tr,
                        style:
                            TextStyle(fontSize: 16, color: Colors.red.shade800),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}