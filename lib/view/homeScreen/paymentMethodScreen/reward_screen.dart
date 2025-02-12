import 'package:flutter/material.dart';
import 'package:live_app/utils/images_path.dart';

import '../../../custom_widgets/custom_text.dart';
import 'widget/reward_card_widget.dart';

class RewardsScreen extends StatefulWidget {
  @override
  _RewardsScreenState createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  String? expandedLevel;

  final List<RewardLevel> levels = [
    RewardLevel(
      level: "Bronze",
      color: Colors.brown,
      rewards: [
        "-3% on prices in the store",
        "-5% on prices in the store",
      ],
      progressItems: [
        ProgressItem(label: "Spend RUB 10,000 or more", value: 4000, max: 10000),
        ProgressItem(label: "Buy 15 items", value: 6, max: 15),
        ProgressItem(label: "Watch 20 streams", value: 7, max: 20),
      ],
    ),
    RewardLevel(level: "Silver", color: Colors.grey, rewards: [
      "-3% on prices in the store",
      "-5% on prices in the store",
    ]),
    RewardLevel(level: "Gold", color: Colors.amber, rewards: [
      "-5% on prices in the store",
      "-8% on prices in the store",
    ]),
    RewardLevel(level: "Diamond", color: Colors.blue, rewards: [
      "-6% on prices in the store",
      "-10% on prices in the store",
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
                    text: 'Company Name',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'SF Pro Rounded',
                    color: Color(0xff2A2A2A),
                  ),
                  CustomText(
                    text: 'Awards Club',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro Rounded',
                    color: Color(0xff2A2A2A),
                  ),
                  SizedBox(height: 10),
                  CustomText(
                    text: 'Subscribe, watch and shop to receive rewards from company_name',
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
                        text: 'Season 2 ends March 3rd',
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
                    text: 'Rewards and progress are reset at the beginning of each season. See more',
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
                  padding: const EdgeInsets.only(bottom: 10,left: 12,right: 12),
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
