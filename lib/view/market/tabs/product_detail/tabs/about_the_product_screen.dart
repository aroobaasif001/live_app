import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_table.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/icons_path.dart';

import 'bid_screen.dart';

class AboutTheProductScreen extends StatelessWidget {

  final String? productDescription;

  const AboutTheProductScreen({super.key,this.productDescription});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text:productDescription!,
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
