import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/images_path.dart';

import '../homeScreen/bottomNaviagtionBar/bottom_nav_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                CustomText(
                  text: "dont_miss_show".tr,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SFProRounded',
                ),
                SizedBox(height: 20),
                CustomContainer(
                  height: 551,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  image: DecorationImage(
                    image: AssetImage(notificationImage),
                    fit: BoxFit.fill
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomText(
                        text: 'be_first_stream'.tr,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SFProRounded',
                      ),
                      SizedBox(height: 8),
                      CustomText(
                        text: 'receive_notifications'.tr,
                        fontSize: 14,
                        color: Colors.grey,
                        textAlign: TextAlign.center,
                        fontFamily: 'MontserratAlternates',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                CustomGradientButton(
                  text: 'continue'.tr,
                  onPressed: () {
                    showDialog(
                      barrierColor: Colors.black.withOpacity(0.5),
                      context: context,
                      builder: (BuildContext context) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Dialog(
                            insetPadding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            child: Container(
                              width: 550,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'want_best'.tr,
                                            style: TextStyle(
                                              fontSize: 28,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'friends'.tr,
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              foreground: Paint()
                                                ..shader = const LinearGradient(
                                                  colors: [
                                                    Color(0xff3392FF),
                                                    Color(0xff7F5BFF),
                                                    Color(0xffE356D7)
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ).createShader(const Rect.fromLTWH(0, 0, 100, 30)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    width: 500,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 19, left: 16, right: 16),
                                          child: Column(
                                            children: [
                                              CustomText(
                                                text: 'want_contacts_title'.tr,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                                textAlign: TextAlign.center,
                                                fontFamily: 'SFProRounded',
                                              ),
                                              CustomText(
                                                text: 'want_contacts_description'.tr,
                                                fontSize: 14,
                                                textAlign: TextAlign.center,
                                                fontFamily: 'SFProRounded',
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () => Get.back(),
                                                child: CustomContainer(
                                                  height: 44,
                                                  border: Border(
                                                    top: BorderSide(color: greyLiteLineColor),
                                                    right: BorderSide(color: greyLiteLineColor),
                                                  ),
                                                  child: Center(
                                                    child: CustomText(
                                                      text: 'dont_allow'.tr,
                                                      fontSize: 16,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Get.offAll(() => BottomNavigationBarWidget());
                                                },
                                                child: CustomContainer(
                                                  height: 44,
                                                  conColor: buttonColor,
                                                  border: Border(
                                                    top: BorderSide(color: greyLiteLineColor),
                                                    left: BorderSide(color: greyLiteLineColor),
                                                  ),
                                                  child: Center(
                                                    child: CustomText(
                                                      text: 'ok'.tr,
                                                      fontSize: 16,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
