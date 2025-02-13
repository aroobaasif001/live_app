import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_review.dart';
import 'package:live_app/custom_widgets/custom_table.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/icons_path.dart';
import 'package:live_app/utils/images_path.dart';
import 'package:live_app/view/market/tabs/payment_screen.dart';
import 'package:live_app/view/market/tabs/product_detail/tabs/about_the_product_screen.dart';
import 'package:live_app/view/market/tabs/product_detail/tabs/seller_information_screen.dart';
import '../../../utils/colors.dart';

class FixCardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Tab count should match TabBarView children count
      child: Scaffold(
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
                    Row(
                      children: [
                        CustomText(
                          text: 'Current rate',
                          color: Color(0xff2A2A2A).withOpacity(0.5),
                        ),
                        SizedBox(width: 13),
                        CustomText(
                          text: '100 ₽',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: CustomContainer(
                              height: 32,
                              border: Border.all(color: Color(0xffC9C9C9)),
                              borderRadius: BorderRadius.circular(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomContainer(
                                    height: 14,
                                    width: 14,
                                    image: DecorationImage(image: AssetImage(saveIcon)),
                                  ),
                                  SizedBox(width: 6),
                                  CustomText(text: '2',color: Colors.black,),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: CustomContainer(
                              height: 32,
                              border: Border.all(color: Color(0xffC9C9C9)),
                              borderRadius: BorderRadius.circular(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomContainer(
                                    height: 14,
                                    width: 14,
                                    image: DecorationImage(image: AssetImage(shareIcon)),
                                  ),
                                  SizedBox(width: 6),
                                  CustomText(text: 'Share',color: Colors.black,),
                                ],
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        CustomContainer(
                          height: 48,
                          width: double.infinity,
                          conColor: Color(0xffE6E6E6),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          border: Border(
                            top: BorderSide(color: conLineColor),
                            left: BorderSide(color: conLineColor),
                            right: BorderSide(color: conLineColor),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomContainer(
                                    height: 32,
                                    width: 32,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(image: AssetImage(appleGBlackImage)),
                                  ),
                                  SizedBox(width: 6),
                                  CustomText(
                                    text: 'company_name',
                                  ),
                                  Spacer(),
                                  CustomContainer(
                                    height: 32,
                                    width: 32,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(image: AssetImage(messageBlackIcon)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        CustomContainer(
                          height: 68,
                          width: double.infinity,
                          conColor: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          border: Border(
                            bottom: BorderSide(color: conLineColor),
                            left: BorderSide(color: conLineColor),
                            right: BorderSide(color: conLineColor),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomReview(value: '4.7',label: 'Rating',iconPath: startIcon),
                                  VerticalDivider(color: conLineColor),
                                  CustomReview(value: '33.8K',label: 'Reviews'),
                                  VerticalDivider(color: conLineColor),
                                  CustomReview(value: '169.7K',label: 'Sold'),
                                  VerticalDivider(color: conLineColor),
                                  CustomReview(value: '+-2d',label: 'Delivery'),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 26),
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
        bottomNavigationBar: CustomContainer(
          height: 92,
          padding: EdgeInsets.all(16),
          child: CustomGradientButton(text: 'Add to cart',),
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            _showBasketModal(context);
          },
          child: CustomContainer(
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
      ),
    );
  }
  void _showBasketModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 50),
                      CustomText(
                        text: 'Backet',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      IconButton(onPressed: () {
                        Get.back();
                      }, icon: Icon(Icons.close)),
                    ],
                  ),
                  ///listview
                  Row(
                    children: [
                      CustomContainer(
                        width: 18,
                        height: 18,
                        image: DecorationImage(image: AssetImage(appleGBlackImage)),
                      ),
                      SizedBox(width: 6),
                      CustomText(text: 'company_name',fontSize: 12,),
                      Row(
                        children: [
                          Icon(Icons.star_rounded,color: Colors.yellow,),
                          CustomText(text: '4.2',fontSize: 12,),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              CustomContainer(
                                  height: 56,
                                  width: 56,
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(image: AssetImage(marketImage),fit: BoxFit.fill)
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: CustomContainer(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: 'Lorem ipsum dolor sit amet consectetur adipiscing elit.',
                                        fontSize: 14,
                                      ),
                                      CustomText(
                                        text: '1,000 ₽',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                  ///listview
                  Row(
                    children: [
                      CustomContainer(
                        width: 18,
                        height: 18,
                        image: DecorationImage(image: AssetImage(appleGBlackImage)),
                      ),
                      SizedBox(width: 6),
                      CustomText(text: 'company_name',fontSize: 12,),
                      Row(
                        children: [
                          Icon(Icons.star_rounded,color: Colors.yellow,),
                          CustomText(text: '4.2',fontSize: 12,),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              CustomContainer(
                                  height: 56,
                                  width: 56,
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(image: AssetImage(marketImage),fit: BoxFit.fill)
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: CustomContainer(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: 'Lorem ipsum dolor sit amet consectetur adipiscing elit.',
                                        fontSize: 14,
                                      ),
                                      CustomText(
                                        text: '1,000 ₽',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'Total:',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        text: '100,000 ₽',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  CustomGradientButton(
                    text: 'Continue',
                    onPressed: () {
                      Get.to(()=> PaymentScreen());
                    },
                  ),
                  SizedBox(height: 10),
                  CustomContainer(
                    height: 5,
                    width: 150,
                    borderRadius: BorderRadius.circular(95.42),
                    conColor: Color(0xff2A2A2A),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}