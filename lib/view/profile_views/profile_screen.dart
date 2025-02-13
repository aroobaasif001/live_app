import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_profile_background_scaffold.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/view/profile_views/my_rewards_screen.dart';
import 'package:live_app/view/profile_views/settings_screen.dart';
import 'package:live_app/view/profile_views/statistic_screen.dart';
import 'package:live_app/view/profile_views/trade_profile_screen.dart';
import 'package:live_app/view/profile_views/wallet_screen.dart';
import '../../utils/icons_path.dart';
import '../../utils/images_path.dart';
import 'create_a_product_screen.dart';
import 'create_streem_screen.dart';
import 'edit_trade_profile.dart';
import 'item_for_auction.dart';
import 'my_products_screen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> settingsOptions = [
      {"icon": Icons.payment, "title": "Payment and delivery"},
      {"icon": Icons.location_on, "title": "Addresses"},
      {"icon": Icons.notifications, "title": "Notifications"},
      {"icon": Icons.email, "title": "Change E-Mail"},
      {"icon": Icons.lock, "title": "Change password"},
      {"icon": Icons.settings, "title": "Settings"},
    ];
    return CustomProfileBackgroundScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(profileImage),
                                fit: BoxFit.fill)),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        children: [
                          CustomText(
                            fontFamily: "SF Pro Rounded",
                            text: "User Name",
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          CustomGradientButton(
                            fontSize: 13,
                            height: 30,
                            borderRadius: 30,
                            width: 110,
                            text: "Trade Profile",
                            onPressed: () {},
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: 155,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(profileAdvertisementImage),
                            fit: BoxFit.cover)),
                  ),
                  CustomText(
                    text: "Account",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  userGroupIcon,
                                  height: 25,
                                  width: 25,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                FittedBox(
                                  child: CustomText(
                                    text: "Referrals and points",
                                    fontFamily: "SF Pro Rounded",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                CustomText(
                                  text: "Balance: 1000 ₽",
                                  fontFamily: "Gilroy-Bold",
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(()=>MyRewardsScreen());
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    crownIcon,
                                    height: 25,
                                    width: 25,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  FittedBox(
                                    child: CustomText(
                                      text: "My Award",
                                      fontFamily: "SF Pro Rounded",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  CustomText(
                                    text: "View coupons",
                                    fontFamily: "Gilroy-Bold",
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: settingsOptions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              settingsOptions[index]['icon'],
                              size: 28,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        title: Text(
                          settingsOptions[index]['title'],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Gilroy-Bold",
                              color: Color(0xff2A2A2A)),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                          size: 28,
                        ),
                        onTap: () {
                         // Get.to(()=> NotificationSettingsScreen());
                         // Get.to(()=> SettingsScreen());
                         // Get.to(()=> EditTradeProfile());
                         // Get.to(()=> MyProductsScreen());
                         // Get.to(()=> CreateProductScreen());
                         // Get.to(()=> WalletScreen());
                         // Get.to(()=> CreateStreamScreen());
                         // Get.to(()=> ItemAuctionScreen());
                         Get.to(()=> StatisticsScreen());
                         // Get.to(()=> TradeProfileScreen());
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 3,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CustomText(
                    text: "Help, contacts",
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    fontFamily: "SF Pro Rounded",
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: settingsOptions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              settingsOptions[index]['icon'],
                              size: 28,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        title: Text(
                          settingsOptions[index]['title'],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Gilroy-Bold",
                              color: Color(0xff2A2A2A)),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                          size: 28,
                        ),
                        onTap: () {
                          // Handle tap actions here
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomContainer(
                    height: 40,
                    width: double.infinity,
                    conColor: Color(0xffE2E2E2),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded),
                        CustomText(
                          text: "Log out",
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          fontFamily: "Gilroy-Bold",
                        ),
                      ],
                    )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
