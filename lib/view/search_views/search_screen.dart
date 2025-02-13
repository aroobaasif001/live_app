import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/view/search_views/search_by_application.dart';
import '../../custom_widgets/custom_container.dart';
import '../../custom_widgets/custom_gradient_button.dart';
import '../../custom_widgets/custom_text.dart';
import '../../utils/icons_path.dart';
import '../../utils/images_path.dart';
import '../homeScreen/widgets/live_video_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child:  TextField(
                    onTap: () {
                      Get.to(()=>SearchByApplication());
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ButtonsTabBar(
                  unselectedBackgroundColor: Colors.white,
                  borderWidth: 0,
                  unselectedBorderColor: Colors.transparent,
                  borderColor: Colors.transparent,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  tabs: [
                    Tab(text: "Top"),
                    Tab(text: "Goods"),
                    Tab(text: "Streams"),
                    Tab(text: "Users"),
                    Tab(text: "Categories"),
                  ],
                ),
                const SizedBox(height: 12),
                // Tab Content
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildTabContent(),
                      _userListView(),
                      Center(child: Text("Streams Tab")),
                      Center(child: Text("Users Tab")),
                      _categoryListView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stream Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Stream",
                fontWeight: FontWeight.w400,
                fontSize: 16,
                fontFamily: "Gilroy-Bold",
              ),
              CustomText(
                text: "See All",
                color: Color(0xff815BFF),
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: "Gilroy-Bold",
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildLiveVideos(context),
          const SizedBox(height: 12),
          CustomGradientButton(text: "Watch More Stream"),
          const SizedBox(height: 12),
          // Users Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Users",
                fontWeight: FontWeight.w400,
                fontSize: 16,
                fontFamily: "Gilroy-Bold",
              ),
              CustomText(
                text: "See All",
                color: Color(0xff815BFF),
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: "Gilroy-Bold",
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildUsers(),
          const SizedBox(height: 12),
          // Products Section
          CustomText(
            text: "All products",
            fontWeight: FontWeight.w400,
            fontSize: 16,
            fontFamily: "Gilroy-Bold",
          ),
          const SizedBox(height: 12),
          _buildProductList(),
        ],
      ),
    );
  }

  Widget _buildLiveVideos(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenWidth > 600 ? 3 : 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.44,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return LiveVideoCard();
            },
          );
        },
      ),
    );
  }

  Widget _buildUsers() {
    return SizedBox(
      height: 165,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                child: Column(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(appleIcon),
                            fit: BoxFit.cover,
                          )),
                    ),
                    SizedBox(height: 8),
                    CustomText(
                      text: "company_name",
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      fontFamily: "Gilroy-Bold",
                    ),
                    SizedBox(height: 2),
                    CustomText(
                      text: "2.3K Subscribers",
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      fontFamily: "Gilroy-Bold",
                    ),
                    SizedBox(height: 8),
                    CustomGradientButton(
                      text: "Subscribe",
                      height: 35,
                      width: 100,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 6,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                height: 136,
                width: 136,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: AssetImage(marketImage), fit: BoxFit.fill),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomGradientButton(
                        height: 21,
                        width: 31,
                        fontSize: 10,
                        text: 'Fix',
                        onPressed: () {},
                      ),
                      CustomContainer(
                        height: 30,
                        width: 45,
                        conColor: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_none_rounded, size: 16),
                            SizedBox(width: 3),
                            CustomText(text: '1')
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        text: 'Product name', fontWeight: FontWeight.bold),
                    CustomText(text: 'Description'),
                    CustomText(text: '1000 ₽', fontWeight: FontWeight.bold),
                    SizedBox(height: 25),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _userListView() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 6,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Image.asset(
                      appleIcon,
                      height: 40,
                      width: 40,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'company_name',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Gilroy-Bold",
                        ),
                        CustomText(
                            color: Color(0xff8C8C8C),
                            fontSize: 14,
                            fontFamily: "Gilroy-Bold",
                            text: '2.4K Subscribers',
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                    Spacer(),
                    CustomGradientButton(
                      text: "Subscribe",
                      width: 100,
                      height: 35,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _categoryListView() {
    return SingleChildScrollView(
      child: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Search by category",
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
            ButtonsTabBar(
              unselectedBackgroundColor: Colors.white,
              borderWidth: 0,
              unselectedBorderColor: Colors.transparent,
              borderColor: Colors.transparent,
              contentPadding:
              EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              tabs: [
                Tab(text: "Recommended"),
                Tab(text: "Popular"),
                Tab(text: "A-Z"),
              ],
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    height: 95,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: primaryGradientColor),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Image.asset(watchVerticalImage),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: "Luxury \naccessories",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xffFFFFFF),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            shape: BoxShape.circle),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      CustomText(
                                        text: "1.1K Views",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xffFFFFFF),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

///

// import 'package:buttons_tabbar/buttons_tabbar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:live_app/custom_widgets/custom_gradient_button.dart';
// import 'package:live_app/custom_widgets/custom_text.dart';
// import 'package:live_app/utils/icons_path.dart';
//
// import '../../custom_widgets/custom_container.dart';
// import '../../utils/images_path.dart';
// import '../homeScreen/homeMainScreen/liveShoppingScreens/live_shopping_screen.dart';
// import '../homeScreen/widgets/live_video_card.dart';
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 5,
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: SafeArea(
//             child: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Search Bar
//                   Container(
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: const TextField(
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: "Search",
//                         prefixIcon: Icon(Icons.search, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   ButtonsTabBar(
//                     unselectedBackgroundColor: Colors.white,
//                     // Background for unselected tabs
//                     borderWidth: 0,
//                     unselectedBorderColor: Colors.transparent,
//                     borderColor: Colors.transparent,
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                     labelStyle: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                     unselectedLabelStyle: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       gradient: LinearGradient(
//                         colors: [Colors.blue, Colors.pinkAccent],
//                         // Gradient for selected tab
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                     tabs: [
//                       Tab(text: "Top"),
//                       Tab(text: "Goods"),
//                       Tab(text: "Streams"),
//                       Tab(text: "Users"),
//                       Tab(text: "Categories"),
//                     ],
//                   ),
//
//                   const SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       CustomText(
//                         text: "Stream",
//                         fontWeight: FontWeight.w400,
//                         fontSize: 16,
//                         fontFamily: "Gilroy-Bold",
//                       ),
//                       CustomText(
//                         text: "See All",
//                         color: Color(0xff815BFF),
//                         fontWeight: FontWeight.w400,
//                         fontSize: 14,
//                         fontFamily: "Gilroy-Bold",
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   _buildLiveVideos(context),
//                   const SizedBox(height: 12),
//                   CustomGradientButton(text: "Watch More Stream"),
//                   const SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       CustomText(
//                         text: "Users",
//                         fontWeight: FontWeight.w400,
//                         fontSize: 16,
//                         fontFamily: "Gilroy-Bold",
//                       ),
//                       CustomText(
//                         text: "See All",
//                         color: Color(0xff815BFF),
//                         fontWeight: FontWeight.w400,
//                         fontSize: 14,
//                         fontFamily: "Gilroy-Bold",
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   SizedBox(
//                     height: 165,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(right: 10),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 15),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     height: 45,
//                                     width: 45,
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         image: DecorationImage(
//                                           image: AssetImage(appleIcon),
//                                           fit: BoxFit.cover,
//                                         )),
//                                   ),
//                                   SizedBox(
//                                     height: 8,
//                                   ),
//                                   CustomText(
//                                     text: "company_name",
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 12,
//                                     fontFamily: "Gilroy-Bold",
//                                   ),
//                                   SizedBox(
//                                     height: 2,
//                                   ),
//                                   CustomText(
//                                     text: "2.3K Subscribers",
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 12,
//                                     fontFamily: "Gilroy-Bold",
//                                   ),
//                                   SizedBox(
//                                     height: 8,
//                                   ),
//                                   CustomGradientButton(
//                                     text: "Subscribe",
//                                     height: 35,
//                                     width: 100,
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   CustomText(
//                     text: "All products",
//                     fontWeight: FontWeight.w400,
//                     fontSize: 16,
//                     fontFamily: "Gilroy-Bold",
//                   ),
//                   const SizedBox(height: 12),
//                   ListView.builder(
//                     physics:NeverScrollableScrollPhysics(),
//                     itemCount: 6,
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 5),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             CustomContainer(
//                               height: 136,
//                               width: 136,
//                               borderRadius: BorderRadius.circular(8),
//                               image: DecorationImage(image: AssetImage(marketImage), fit: BoxFit.fill),
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     CustomGradientButton(
//                                         height: 21, width: 31, fontSize: 10, text: 'Fix', onPressed: () {}),
//                                     CustomContainer(
//                                       height: 30,
//                                       width: 45,
//                                       conColor: Colors.white,
//                                       borderRadius: BorderRadius.circular(100),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Icon(Icons.notifications_none_rounded, size: 16),
//                                           SizedBox(width: 3),
//                                           CustomText(text: '1')
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   CustomText(
//                                     text: 'Product name',
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   CustomText(
//                                     text: 'Description',
//                                   ),
//                                   CustomText(
//                                     text: '1000 ₽',
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   SizedBox(height: 25),
//                                   CustomGradientButton(
//                                     text: 'text',
//                                     onPressed: () {},
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLiveVideos(
//     BuildContext context,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           double screenWidth = constraints.maxWidth;
//
//           return GestureDetector(
//             onTap: () {
//               Get.to(() => LiveShoppingScreen());
//             },
//             child: GridView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: screenWidth > 600 ? 3 : 2,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 childAspectRatio: 0.44,
//               ),
//               itemCount: 6,
//               itemBuilder: (context, index) {
//                 return LiveVideoCard();
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
