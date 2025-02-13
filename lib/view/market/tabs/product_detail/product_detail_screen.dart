import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_table.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/icons_path.dart';
import 'package:live_app/utils/images_path.dart';
import 'package:live_app/view/market/tabs/product_detail/tabs/about_the_product_screen.dart';
import 'package:live_app/view/market/tabs/product_detail/tabs/seller_information_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Tab// count should match TabBarView children count
      child: Scaffold(
        backgroundColor: Color(0xffC9C9C9),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                height: 376,
                width: double.infinity,
                image: DecorationImage(image: AssetImage(iphoneImage), fit: BoxFit.fill),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, right: 12),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Get.back();
                      },
                      icon: CustomContainer(
                        height: 30,
                        width: 30,
                        conColor: Colors.white,
                        shape: BoxShape.circle,
                        child: Icon(Icons.close),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Iphone 16 PRO MAX 512 GB',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SFProRounded',
                    ),
                    SizedBox(height: 6),
                    CustomText(
                      text: 'Iphone - New - Original',
                      fontFamily: "Gilroy",
                      fontSize: 17,
                    ),
                    SizedBox(height: 13),
                    CustomContainer(
                      height: 22,
                      width: 61,
                      alignment: Alignment.center,
                      borderRadius: BorderRadius.circular(4),
                      conColor: Color(0xff7246F1).withOpacity(0.1),
                      child: CustomText(
                        text: 'Sold Out',
                        fontSize: 12,
                        color: Color(0xff7246F1),
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomTable(
                      leftText: 'Selling price',
                      rightText: '100,000 ₽',
                    ),
                    CustomTable(
                      leftText: 'Type of sale',
                      rightText: 'Auction',
                      conColor: Colors.white,
                    ),
                    CustomTable(
                      image: appleGBlackImage,
                      leftText: 'Buyer',
                      rightText: 'company_name',
                    ),
                    CustomTable(
                      image: appleGBlackImage,
                      leftText: 'Seller',
                      rightText: 'company_name',
                      conColor: Colors.white,
                    ),
                    CustomTable(
                      leftText: 'Date of sale',
                      rightText: 'September 25, 2022',
                    ),
                    SizedBox(height: 12),
                    Divider(color: conLineColor),
                    SizedBox(height: 12),
                    ButtonsTabBar(
                      unselectedBackgroundColor: Colors.white,
                      borderWidth: 0,
                      elevation: 0.0001,
                      unselectedBorderColor: Colors.transparent,
                      borderColor: Colors.transparent,
                      radius: 8,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      buttonMargin: EdgeInsets.symmetric(horizontal: 10),
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
                          colors: [Colors.blue, Colors.pinkAccent], // Gradient for selected tab
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      tabs: [
                        Tab(text: 'About the product'),
                        Tab(text: 'Seller Information'),
                      ],
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
              CustomContainer(
                height: MediaQuery.of(context).size.height,
                child: TabBarView(
                  children: [
                    /// **First Tab: About the Product**
                    AboutTheProductScreen(),
                    /// **Second Tab: Seller Information**
                    SellerInformationScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: CustomContainer(
          height: 50,
          width: 120,
          borderRadius: BorderRadius.circular(100),
          conColor: Colors.white,
          boxShadow: [
            BoxShadow(
                color: greyColor,
                blurRadius: 5,
                offset: Offset(-1, 3)
            )
          ],
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
                  CustomText(text: '1000 ₽',color: Colors.white)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}