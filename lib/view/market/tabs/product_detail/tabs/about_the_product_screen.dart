import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_report_dialog.dart';
import 'package:live_app/custom_widgets/custom_table.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/icons_path.dart';

import 'bid_screen.dart';

class AboutTheProductScreen extends StatelessWidget {
  final String? productDescription;

  const AboutTheProductScreen({Key? key, this.productDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: productDescription ?? '',
            fontSize: 13,
          ),
          const SizedBox(height: 20),
          CustomTable(
            leftText: 'category'.tr,
            rightText: 'modern_games'.tr,
          ),
          CustomTable(
            leftText: 'platform'.tr,
            rightText: 'nintendo_switch'.tr,
            conColor: Colors.white,
          ),
          CustomTable(
            leftText: 'notes'.tr,
            rightText: 'new_from_factory'.tr,
          ),
          const SizedBox(height: 20),
          CustomText(
            text: 'buyer_protection'.tr,
            fontSize: 18,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (ctx) => Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: BidScreen(),
                ),
              );
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
                const SizedBox(width: 10),
                // Prevent overflow by expanding text area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'grab_it'.tr,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      CustomText(
                        text: 'friend_receives_amount'.tr,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_forward_ios_rounded),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(color: conLineColor),
          const SizedBox(height: 10),
          Row(
            children: [
              CustomText(text: 'created_date'.tr),
              const SizedBox(width: 20),
              InkWell(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => const CustomReportDialog(),
                  );
                },
                child: CustomText(
                  text: 'report_abuse'.tr,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
