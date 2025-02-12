import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_icon_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/utils/images_path.dart';
import 'package:live_app/view/market/tabs/for_you_screen.dart';
import 'package:readmore/readmore.dart';
import '../../utils/colors.dart';
import '../../utils/icons_path.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomContainer(
                  height: 280,
                  child: Stack(
                    children: [
                      CustomContainer(
                        width: double.infinity,
                        height: 220,
                        image: DecorationImage(image: AssetImage(marketImage), fit: BoxFit.cover),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomContainer(
                                    height: 77,
                                    width: 77,
                                    image: DecorationImage(image: AssetImage(circleAppleImage)),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: CustomContainer(
                                        height: 30,
                                        width: 30,
                                        image: DecorationImage(image: AssetImage(circleButtonImage)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: 'company_name',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      CustomText(
                                        text: 'Company Name',
                                        color: Colors.white,
                                      ),
                                      Row(
                                        children: [
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(text: '95K ', style: TextStyle(color: Colors.white)),
                                              TextSpan(
                                                  text: 'Subscribers', style: TextStyle(color: Colors.white54)),
                                              TextSpan(text: ' . '),
                                              TextSpan(
                                                  text: '132 Subscriptions',
                                                  style: TextStyle(color: Colors.white54)),
                                            ]),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 50)
                            ],
                          ),
                        ),
                      ),
                      // **Statistics**
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CustomContainer(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _buildStatItem('4.7', 'Rating'),
                                    VerticalDivider(color: conLineColor),
                                    _buildStatItem('33.8K', 'Reviews'),
                                    VerticalDivider(color: conLineColor),
                                    _buildStatItem('169.7K', 'Sold'),
                                    VerticalDivider(color: conLineColor),
                                    _buildStatItem('+2d', 'Delivery'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // **Main Content with Scroll Fix**
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // **Description**
                          ReadMoreText(
                            'Lorem ipsum dolor sit amet consectetur adipiscing elit Ut et massa mi. Aliquam in hendrerit urna.',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            trimMode: TrimMode.Line,
                            trimLines: 1,
                            colorClickableText: Colors.grey,
                            lessStyle: TextStyle(color: viewColor),
                            trimCollapsedText: 'View more',
                            trimExpandedText: 'View less',
                            moreStyle: TextStyle(color: viewColor),
                          ),
                          SizedBox(height: 10),
                          // **Buttons**
                          CustomGradientButton(
                            width: double.infinity,
                            text: 'Subscribe',
                            onPressed: () {},
                          ),
                          SizedBox(height: 10),

                          Row(
                            children: [
                              Expanded(
                                child: CustomIconButton(onPressed: () {}, text: 'Message', iconPath: messageIcon),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: CustomIconButton(onPressed: () {}, text: 'Tips', iconPath: tipsIcon),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(color: conLineColor),
                          // **Tabs**
                          ButtonsTabBar(
                            unselectedBackgroundColor: Colors.white, // Background for unselected tabs
                            borderWidth: 0,
                            unselectedBorderColor: Colors.transparent,
                            borderColor: Colors.transparent,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            labelStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14,
                            ),
                            unselectedLabelStyle: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [Colors.blue, Colors.pinkAccent], // Gradient for selected tab
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            tabs: [
                              Tab(text: "For you"),
                              Tab(text: "Streams"),
                              Tab(text: "Reviews"),
                              Tab(text: "Clips"),
                              Tab(text: "Past"),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
                CustomContainer(
                  height: Get.height,
                  child: TabBarView(children: [
                    ForYouScreen(),
                    CustomText(text: "Streams"),
                    CustomText(text: "Reviews"),
                    CustomText(text: "Clips"),
                    CustomText(text: "Past"),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: value,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        CustomText(
          text: label,
          fontSize: 14,
          color: Colors.grey,
        ),
      ],
    );
  }
}
