import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/controller/read_more_controller.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_review.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/icons_path.dart';
import 'package:live_app/utils/images_path.dart';

class SellerInformationScreen extends StatelessWidget {
  const SellerInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReadMoreController controller = Get.put(ReadMoreController());

    return Scaffold(
      backgroundColor: Color(0xffC9C9C9),
      body: Stack(
        children: [
          /// **Main Seller Information (Background Content)**
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomContainer(
                  height: 290,
                  child: Stack(
                    children: [
                      CustomContainer(
                        width: double.infinity,
                        height: 210,
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(image: AssetImage(marketImage), fit: BoxFit.fill),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomContainer(
                              height: 94,
                              width: 94,
                              image: DecorationImage(image: AssetImage(circleAppleImage)),
                            ),
                            SizedBox(height: 12),
                            CustomText(
                              text: 'Company_Name',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16),
                CustomContainer(
                  height: 68,
                  width: double.infinity,
                  conColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: conLineColor),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomReview(value: '4.7', label: 'Rating', iconPath: startIcon),
                          VerticalDivider(color: conLineColor),
                          CustomReview(value: '33.8K', label: 'Reviews'),
                          VerticalDivider(color: conLineColor),
                          CustomReview(value: '169.7K', label: 'Sold'),
                          VerticalDivider(color: conLineColor),
                          CustomReview(value: '+-2d', label: 'Delivery'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// **Draggable Scrollable Sheet**
          DraggableScrollableSheet(
            initialChildSize: 0.45, // Default size when opened
            minChildSize: 0.45, // Minimum scroll size
            maxChildSize: 0.9, // Maximum full-screen size
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Color(0xffC9C9C9),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController, // Enables drag scrolling
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                CustomText(
                                  text: "WELCOME TO GRAND GAMING\nINCREDIBLE DEALS, ENERGY BOOSTS, FAST AUCTIONS\nFAIRFUNFAST\nPLEASE CONTACT ME WITH ANY QUESTIONS OR PROBLEMS, I'M HERE TO HELP!",
                                ),
                                SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {},
                                  child: CustomContainer(
                                    height: 40,
                                    width: double.infinity,
                                    borderRadius: BorderRadius.circular(10),
                                    conColor: Color(0xffE2E2E2),
                                    alignment: Alignment.center,
                                    child: CustomText(text: 'View Profile'),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(text: 'Reviews about the seller', fontSize: 18, fontWeight: FontWeight.bold),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          CustomText(text: 'View all', color: Color(0xff815BFF), fontWeight: FontWeight.bold),
                                          SizedBox(width: 2),
                                          Icon(Icons.arrow_forward_ios_rounded, size: 15, color: Color(0xff815BFF)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Obx(() => SizedBox(
                                  height: controller.readMore.value ? 400 : 210, // Dynamic height
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                        child: Container(
                                          width: 350,
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.1),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: AssetImage(girlImage), // Replace with actual image path
                                                    radius: 20,
                                                  ),
                                                  SizedBox(width: 10),
                                                  CustomText(text: 'nickname25', fontWeight: FontWeight.bold),
                                                  Spacer(),
                                                  Icon(Icons.more_horiz, color: Colors.grey),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  CustomText(text: '3.8', fontWeight: FontWeight.bold),
                                                  ShaderMask(
                                                    shaderCallback: (Rect bounds) {
                                                      return LinearGradient(
                                                        colors: [Color(0xff60C0FF), Color(0xffE356D7)],
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                      ).createShader(bounds);
                                                    },
                                                    child: Icon(Icons.star, size: 16, color: Colors.white),
                                                  ),
                                                  SizedBox(width: 10),
                                                  CustomText(text: '21.01.2025'),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              /// **Description**
                                              Obx(() => Text(
                                                'Lorem ipsum dolor sit amet consectetur adipiscing elit Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit',
                                                maxLines: controller.readMore.value ? null : 2,
                                                overflow: controller.readMore.value ? TextOverflow.visible : TextOverflow.ellipsis,
                                              )),
                                              SizedBox(height: 10),
                                              // **See more / See less button**
                                              GestureDetector(
                                                onTap: () {
                                                  controller.toggleReadMore(); // Toggle state
                                                },
                                                child: Row(
                                                  children: [
                                                    Obx(() => CustomText(
                                                      text: controller.readMore.value ? 'See less' : 'See more',
                                                      color: Color(0xff815BFF),
                                                      fontWeight: FontWeight.bold,
                                                    )),
                                                    Obx(() => Icon(
                                                      controller.readMore.value ? Icons.expand_less : Icons.expand_more,
                                                      color: Color(0xff815BFF),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 12),
                                              if (controller.readMore.value)
                                                Column(
                                                  children: [
                                                    SizedBox(height: 12),
                                                    CustomContainer(
                                                      height: 37,
                                                      conColor: Color(0xff000000).withOpacity(0.05),
                                                      borderRadius: BorderRadius.circular(6),
                                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          CustomText(text: 'Generally',fontWeight: FontWeight.w600,),
                                                          Row(
                                                            children: [
                                                              Icon(Icons.star_rounded,color: Colors.yellow,),
                                                              SizedBox(width: 4),
                                                              CustomText(text: '4.7')
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    CustomContainer(
                                                      height: 37,
                                                      conColor: Colors.white,
                                                      borderRadius: BorderRadius.circular(6),
                                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          CustomText(text: 'Generally',fontWeight: FontWeight.w600,),
                                                          Row(
                                                            children: [
                                                              Icon(Icons.star_rounded,color: Colors.yellow,),
                                                              SizedBox(width: 4),
                                                              CustomText(text: '4.7')
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    CustomContainer(
                                                      height: 37,
                                                      conColor: Color(0xff000000).withOpacity(0.05),
                                                      borderRadius: BorderRadius.circular(6),
                                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          CustomText(text: 'Generally',fontWeight: FontWeight.w600,),
                                                          Row(
                                                            children: [
                                                              Icon(Icons.star_rounded,color: Colors.yellow,),
                                                              SizedBox(width: 4),
                                                              CustomText(text: '4.7')
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    CustomContainer(
                                                      height: 37,
                                                      conColor: Colors.white,
                                                      borderRadius: BorderRadius.circular(6),
                                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          CustomText(text: 'Generally',fontWeight: FontWeight.w600,),
                                                          Row(
                                                            children: [
                                                              Icon(Icons.star_rounded,color: Colors.yellow,),
                                                              SizedBox(width: 4),
                                                              CustomText(text: '4.7')
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )

                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )),
                                SizedBox(height: 20),
                                CustomContainer(
                                  height: 212,
                                  conColor: Color(0xffFFFFFF),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Column(
                                    children: [
                                      CustomContainer(
                                        height: 35,
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        gradient: LinearGradient(colors: [
                                          Color(0xff60C0FF).withOpacity(0.2),
                                          Color(0xffE356D7).withOpacity(0.2),
                                        ]),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(text: 'Purchase from 21.02.25',color: Colors.black,),
                                            CustomText(text: '1000 ₽'),
                                          ],
                                        ),
                                      ),
                                      CustomContainer(
                                        padding: EdgeInsets.only(top: 12,right: 12,left: 12),
                                        child: Row(
                                          children: [
                                            CustomContainer(
                                              width: 56,
                                              height: 56,
                                              borderRadius: BorderRadius.circular(8),
                                              image: DecorationImage(image: AssetImage(marketImage),fit: BoxFit.fill),
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  text: 'Product name',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                CustomText(
                                                  text: 'Description',
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                                CustomText(
                                                  text: '1,000 ₽',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            text: '3 more items',
                                            fontSize: 14,
                                            color: Color(0xff815BFF),
                                          ),
                                          Icon(Icons.keyboard_arrow_down_rounded,color: Color(0xff815BFF),)
                                        ],
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 12,right: 12,left: 12),
                                        child: CustomGradientButton(
                                          text: 'Leave feedback',
                                          onPressed: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                CustomText(
                                  text: 'More from this seller',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 260,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 150,
                                        margin: EdgeInsets.only(right: 10),
                                        child: Column(
                                          children: [
                                            CustomContainer(
                                              height: 160,
                                              width: 160,
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(image: AssetImage(iphoneImage)),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 10,
                                                    right: 10,
                                                    child: CustomContainer(
                                                      alignment: Alignment.center,
                                                      height: 30,
                                                      width: 47,
                                                      borderRadius: BorderRadius.circular(100),
                                                      conColor: Colors.white,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          CustomContainer(
                                                            height: 16,
                                                            width: 16,
                                                            image: DecorationImage(image: AssetImage(saveIcon)),
                                                          ),
                                                          SizedBox(width: 5),
                                                          CustomText(text: '6')
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 10,
                                                    left: 10,
                                                    child: CustomContainer(
                                                      alignment: Alignment.center,
                                                      height: 24,
                                                      width: 80,
                                                      borderRadius: BorderRadius.circular(6),
                                                      conColor: Colors.red,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(CupertinoIcons.waveform,color: Colors.white,),
                                                          SizedBox(width: 3),
                                                          CustomText(
                                                            text: 'Stream',
                                                            fontSize: 13,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            CustomText(
                                              text: 'Lorem ipsum dolor sit amet consectetur',
                                              fontSize: 14,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            CustomText(
                                              text: '100,000 ₽',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            CustomText(
                                              text: 'Iphone . New . Original',
                                              fontSize: 12,
                                            ),
                                          ],
                                        ),
                                      );
                                    },),
                                ),
                                Divider(color: Color(0xff000000).withOpacity(0.05),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: 'Created 01/28/25',
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    CustomText(
                                      text: 'Report Abuse',
                                      fontSize: 14,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          CustomContainer(
                            height: 92,
                            conColor: Colors.white,
                            child: Center(
                              child: CustomGradientButton(
                                text: 'Add to cart',
                                onPressed: () {},
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
