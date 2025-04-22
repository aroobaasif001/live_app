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
            text:productDescription ?? '',
            fontSize: 13,
          ),
          SizedBox(height: 20),
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
          SizedBox(height: 20),
          CustomText(
            text: 'buyer_protection'.tr,
            fontSize: 18,
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                scrollControlDisabledMaxHeightRatio: MediaQuery.of(context).size.height * 2,
                builder: (context) => Container(
                  height: MediaQuery.of(context).size.height * 0.8, // adjust as needed
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white
                  ),
                  child: BidScreen(), // this will show the BidScreen as a popup
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
                SizedBox(width: 5),
                CustomContainer(
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
              CustomText(text: 'created_date'.tr),
              SizedBox(width: 20),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      TextEditingController reportController = TextEditingController();

                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.white,
                        title: CustomText(
                          text: 'Report Abuse',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: reportController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Write your report here...',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffC0241E), // red color
                              ),
                              onPressed: () {
                                String reportText = reportController.text;
                                if (reportText.isNotEmpty) {
                                  // Do something like submit to Firebase or backend
                                  Navigator.pop(context); // Close dialog
                                  Get.snackbar('Report', 'Your report has been submitted.');
                                } else {
                                  Get.snackbar('Error', 'Please write something before submitting.');
                                }
                              },
                              child: CustomText(
                                text: 'Submit',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
          )
        ],
      ),
    );
  }
}
