import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_table.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/icons_path.dart';

import 'bid_screen.dart';

class AboutTheProductScreen extends StatelessWidget {
  const AboutTheProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: """Min: 2000 ₽, Max - 35000 ₽, Avg - 4048 ₽AT THE GRAND GAME SHOW
-48 SEATS-EVERYTHING FROM 1 DOLLAR-NINTENDO SWITCH SET WORTH \$300 (CONSOLE, GAMES AND MORE)-NINTENDO SWITCH, PLAYSTATION 4/5, FOR XBOX-THERE WILL BE A TON OF BUFFERS FOR THOSE OF YOU WHO RECEIVED A GAME THAT WAS NOT INTERESTING TO THEM.
Rules-48 WHITE BOXES WILL APPEAR ON THE SCREEN-A TOTAL OF 48 AUCTIONS WILL BE HELD, EACH OF WHICH STARTS AT ONLY \$1-WINNING AN AUCTION WILL GIVE YOU ACCESS TO CHOOSE 1 OF THE 48 WHITE BOXES-YOUR NAME WILL BE INDICATED IN THE BOX YOU CHOSEN-IN THE END, THERE ARE 48 AUCTIONS WE WILL OPEN IN ORDER OF PURCHASE-CLIENT NAMES WILL BE CLEARLY STATED BEFORE THE BOXES ARE OPENED-THE GRAND PRIZE WILL CONTAIN A SPECIAL JOKER INSIDE IS THERE A PLAYING CARD? THE SELLER IS ALWAYS HAPPY TO EXPLAIN THE RULES OF THE GAME""",
            fontSize: 13,
          ),
          SizedBox(height: 20),
          CustomTable(
            leftText: 'Category',
            rightText: 'Modern games',
          ),
          CustomTable(
            leftText: 'Platform',
            rightText: 'Nintendo Switch',
            conColor: Colors.white,
          ),
          CustomTable(
            leftText: 'Notes',
            rightText: 'New, From the factory',
          ),
          SizedBox(height: 20),
          CustomText(
            text: 'Buyer protection',
            fontSize: 18,
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Get.to(()=> BidScreen());
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomContainer(
                  height: 52,
                  width: 52,
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage(miniIcon)),
                ),
                SizedBox(width: 5),
                CustomContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Grab it! Guarantee of protection',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      CustomText(
                        text: 'Your friend receives a random amount\nbetween 100 ₽ and 2000 ₽',
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios_rounded)
              ],
            ),
          ),
          SizedBox(height: 10),
          Divider(color: conLineColor),
          SizedBox(height: 10),
          Row(
            children: [
              CustomText(text: 'Created 01/28/25'),
              SizedBox(width: 20),
              CustomText(text: 'Report Abuse',color: Color(0xffC0241E),),
            ],
          )
        ],
      ),
    );
  }
}
