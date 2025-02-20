import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_icon_button.dart';
import 'package:live_app/custom_widgets/custom_review.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/utils/images_path.dart';
import 'package:live_app/view/market/tabs/clips_screen.dart';
import 'package:live_app/view/market/tabs/for_you_screen.dart';
import 'package:live_app/view/market/tabs/reviews_screen.dart';
import 'package:readmore/readmore.dart';
import '../../entities/registration_entity.dart';
import '../../utils/colors.dart';
import '../../utils/icons_path.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  Stream<DocumentSnapshot<RegistrationEntity>> getUserData =
      RegistrationEntity.doc(userId: FirebaseAuth.instance.currentUser!.uid).snapshots();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
              child: StreamBuilder(
            stream: getUserData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var userData = snapshot.data!.data();
              return Column(
                children: [
                  CustomContainer(
                    height: 280,
                    child: Stack(
                      children: [
                        CustomContainer(
                          width: double.infinity,
                          height: 220,
                          image: userData?.coverImage != null && userData!.coverImage!.isNotEmpty
                              ? DecorationImage(
                                  fit: BoxFit.cover, image: NetworkImage(userData.coverImage.toString()))
                              : DecorationImage(fit: BoxFit.cover, image: AssetImage(marketImage)),
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
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: userData?.image != null && userData!.image!.isNotEmpty
                                            ? NetworkImage(userData.image.toString())
                                            : AssetImage(circleAppleImage),
                                      ),
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
                                    Expanded(
                                      // Wrap this column in Expanded
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: userData?.firstName ?? '',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          CustomText(
                                            text: userData?.lastName ?? '',
                                            color: Colors.white,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '95K ',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                TextSpan(
                                                  text: 'Subscribers'.tr,
                                                  style: TextStyle(color: Colors.white54),
                                                ),
                                                TextSpan(text: ' . '),
                                                TextSpan(
                                                  text: '132 Subscriptions'.tr,
                                                  style: TextStyle(color: Colors.white54),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                      CustomReview(
                                          value: userData?.rating ?? '',
                                          label: 'Rating'.tr,
                                          iconPath: startIcon),
                                      VerticalDivider(color: conLineColor),
                                      CustomReview(value: userData?.reviews ?? '', label: 'Reviews'.tr),
                                      VerticalDivider(color: conLineColor),
                                      CustomReview(value: userData?.sold ?? '', label: 'Sold'.tr),
                                      VerticalDivider(color: conLineColor),
                                      CustomReview(value: userData?.delivery ?? '', label: 'Delivery'.tr),
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
                              trimCollapsedText: 'View more'.tr,
                              trimExpandedText: 'View less'.tr,
                              moreStyle: TextStyle(color: viewColor),
                            ),
                            SizedBox(height: 10),
                            // **Buttons**
                            CustomGradientButton(
                              width: double.infinity,
                              text: 'Subscribe'.tr,
                              onPressed: () {},
                            ),
                            SizedBox(height: 10),

                            Row(
                              children: [
                                Expanded(
                                  child: CustomIconButton(
                                      onPressed: () {}, text: 'Message'.tr, iconPath: messageIcon),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child:
                                      CustomIconButton(onPressed: () {}, text: 'Tips'.tr, iconPath: tipsIcon),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Divider(color: conLineColor),
                            // **Tabs**
                            ButtonsTabBar(
                              unselectedBackgroundColor: Colors.white,
                              // Background for unselected tabs
                              borderWidth: 0,
                              unselectedBorderColor: Colors.transparent,
                              borderColor: Colors.transparent,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              unselectedLabelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.pinkAccent],
                                  // Gradient for selected tab
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              tabs: [
                                Tab(text: "For you".tr),
                                Tab(text: "Streams".tr),
                                Tab(text: "Reviews".tr),
                                Tab(text: "Clips".tr),
                                Tab(text: "Past Streams".tr),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                  CustomContainer(
                    height: screenHeight,
                    child: TabBarView(children: [
                      ForYouScreen(),
                      CustomText(text: "Streams".tr),
                      ReviewsScreen(),
                      ClipsScreen(),
                      CustomText(text: "Past Streams".tr),
                    ]),
                  )
                ],
              );
            },
          )),
        ),
        floatingActionButton: CustomContainer(
          height: 50,
          width: 120,
          borderRadius: BorderRadius.circular(100),
          conColor: Colors.white,
          boxShadow: [BoxShadow(color: greyColor, blurRadius: 5, offset: Offset(-1, 3))],
          child: Center(
            child: CustomContainer(
              height: 44,
              width: 111,
              borderRadius: BorderRadius.circular(100),
              gradient: primaryGradientColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomContainer(
                    height: 24,
                    width: 24,
                    image: DecorationImage(image: AssetImage(storeIcon)),
                  ),
                  CustomText(text: '1000 ₽', color: Colors.white)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
