import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/utils/images_path.dart';

import '../../../custom_widgets/custom_text.dart';
import '../homeScreen/paymentMethodScreen/widget/reward_card_widget.dart';

class RewardsScreen extends StatefulWidget {
  @override
  _RewardsScreenState createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  String? expandedLevel;

  final List<RewardLevel> levels = [
    RewardLevel(
      level: "bronze".tr,
      color: Colors.brown,
      rewards: [
        "-3% ${'store_discount'.tr}",
        "-5% ${'store_discount'.tr}"
      ],
      progressItems: [
        ProgressItem(label: "spend_rub".trParams({"amount": "10,000"}), value: 4000, max: 10000),
        ProgressItem(label: "buy_items".trParams({"count": "15"}), value: 6, max: 15),
        ProgressItem(label: "watch_streams".trParams({"count": "20"}), value: 7, max: 20),
      ],
    ),
    RewardLevel(level: "silver".tr, color: Colors.grey, rewards: [
      "-3% ${'store_discount'.tr}",
      "-5% ${'store_discount'.tr}",
    ]),
    RewardLevel(level: "gold".tr, color: Colors.amber, rewards: [
      "-5% ${'store_discount'.tr}",
      "-8% ${'store_discount'.tr}",
    ]),
    RewardLevel(level: "diamond".tr, color: Colors.blue, rewards: [
      "-6% ${'store_discount'.tr}",
      "-10% ${'store_discount'.tr}",
    ]),
  ];

  final List<String> rewardImages = [
    bronzeAwardImage,
    silverAwardImage,
    goldAwardImage,
    diamondAwardImage,
    platinumAwardImage,
  ];

  void toggleExpansion(String level) {
    setState(() {
      expandedLevel = (expandedLevel == level) ? null : level;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 120, bottom: 20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/rewardbg.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/appleg.png', height: 94),
                  SizedBox(height: 10),
                  CustomText(
                    text: 'company_name'.tr,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'SF Pro Rounded',
                    color: Color(0xff2A2A2A),
                  ),
                  CustomText(
                    text: 'awards_club'.tr,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro Rounded',
                    color: Color(0xff2A2A2A),
                  ),
                  SizedBox(height: 10),
                  CustomText(
                    text: 'subscribe_watch_shop'.trParams({"company_name": "Company Name"}),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Gilroy-Bold',
                    textAlign: TextAlign.center,
                    color: Color(0xff2A2A2A),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xffFF6000),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: CustomText(
                        text: 'season_ends'.trParams({"date": "March 3rd"}),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Gilroy-Bold',
                        textAlign: TextAlign.center,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomText(
                    text: 'reset_rewards_progress'.tr,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Gilroy-Bold',
                    textAlign: TextAlign.center,
                    color: Color(0xff2A2A2A),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: rewardImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(rewardImages[index]),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 