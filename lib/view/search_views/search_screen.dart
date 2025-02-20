import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/view/search_views/search_by_application.dart';
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
                const SizedBox(height: 15),
                // Search Bar
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    onTap: () {
                      // Opens "SearchByApplication" screen
                      Get.to(() => const SearchByApplication());
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'search'.tr,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Top-level TabBar
                ButtonsTabBar(
                  unselectedBackgroundColor: Colors.white,
                  borderWidth: 0,
                  unselectedBorderColor: Colors.transparent,
                  borderColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.pinkAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  tabs: [
                    Tab(text: 'top'.tr),
                    Tab(text: 'goods'.tr),
                    Tab(text: 'streams'.tr),
                    Tab(text: 'users'.tr),
                    Tab(text: 'categories'.tr),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildTopTab(),
                      _buildGoodsTab(),
                      _buildStreamsTab(),
                      _buildUsersTab(),
                      _buildCategoriesTab(),
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

  // ===========================================================================
  // =============================  TOP TAB  ====================================
  // ===========================================================================
  Widget _buildTopTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16), // extra bottom spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STREAM SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "stream".tr,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  fontFamily: "Gilroy-Bold",
                ),
                CustomText(
                  text: "see_all".tr,
                  color: const Color(0xff815BFF),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontFamily: "Gilroy-Bold",
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStreamGrid(context), // 2×2
            const SizedBox(height: 12),
            // "Watch more streams" button

            CustomGradientButton(text: "watch_more_streams".tr),

            const SizedBox(height: 12),

            // USERS SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "users".tr,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  fontFamily: "Gilroy-Bold",
                ),
                CustomText(
                  text: "see_all".tr,
                  color: const Color(0xff815BFF),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontFamily: "Gilroy-Bold",
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildHorizontalUsers(itemCount: 3),
            const SizedBox(height: 12),

            // PRODUCTS SECTION
            CustomText(
              text: "all_products".tr,
              fontWeight: FontWeight.w400,
              fontSize: 16,
              fontFamily: "Gilroy-Bold",
            ),
            const SizedBox(height: 12),
            // Updated to match your screenshot design
            _buildProductList(itemCount: 3),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // ============================  GOODS TAB  ===================================
  // ===========================================================================
  Widget _buildGoodsTab() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon + “company_name” + “2.4K Subscribers”
              Expanded(
                child: Row(
                  children: [
                    Image.asset(
                      appleIcon,
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'company_name'.tr,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Gilroy-Bold",
                        ),
                        CustomText(
                          color: const Color(0xff8C8C8C),
                          fontSize: 14,
                          fontFamily: "Gilroy-Bold",
                          text: '2.4K Subscribers',
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CustomGradientButton(
                text: "Subscribe",
                width: 100,
                height: 35,
              ),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // ===========================  STREAMS TAB  ==================================
  // ===========================================================================
  Widget _buildStreamsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStreamGrid(
              context
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // ============================  USERS TAB  ===================================
  // ===========================================================================
  Widget _buildUsersTab() {
    return ListView.builder(
      itemCount: 6,
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
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'company_name'.tr,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Gilroy-Bold",
                        ),
                        CustomText(
                          color: const Color(0xff8C8C8C),
                          fontSize: 14,
                          fontFamily: "Gilroy-Bold",
                          text: '2.4K Subscribers',
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CustomGradientButton(
                text: "Subscribe",
                width: 100,
                height: 35,
              ),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // =========================  CATEGORIES TAB  =================================
  // ===========================================================================
  Widget _buildCategoriesTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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
            const SizedBox(height: 8),
            ButtonsTabBar(
              unselectedBackgroundColor: Colors.white,
              borderWidth: 0,
              unselectedBorderColor: Colors.transparent,
              borderColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              labelStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: primaryGradientColor,
              ),
              tabs: const [
                Tab(text: "Recommended"),
                Tab(text: "Popular"),
                Tab(text: "A-Z"),
              ],
            ),
            SizedBox(
              height: 500, // enough space for sub-tab content
              child: TabBarView(
                children: [
                  _buildCategoryList(),
                  _buildCategoryList(),
                  _buildCategoryList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    final categories = [
      "Luxury accessories",
      "Everyday Electronics",
      "Video games",
      "Shoes",
      "Cloth",
    ];
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(
            height: 95,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: primaryGradientColor,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(
                        watchVerticalImage,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: categories[index],
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffFFFFFF),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 20),
                              CustomText(
                                text: "1.1K Views",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xffFFFFFF),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
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
    );
  }
  Widget _buildHorizontalUsers({required int itemCount}) {
    return SizedBox(
      height: 165,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                child: Column(
                  children: [
                    // user image
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(appleIcon),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      text: "company_name".tr,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      fontFamily: "Gilroy-Bold",
                    ),
                    const SizedBox(height: 2),
                    CustomText(
                      text: "2.3K Subscribers",
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      fontFamily: "Gilroy-Bold",
                    ),
                    const SizedBox(height: 8),
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
  Widget _buildProductList({required int itemCount}) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.shade300,
        thickness: 1,
        height: 20,
      ),
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: product image with small badge (icon + "3")
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      marketImage,
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 3),
                          CustomText(
                            text: '3',
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Right side: brand name + rating, product name, description, price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // brand name + star rating row
                  Row(
                    children: [
                      Image.asset(
                        appleIcon,
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 6),
                      CustomText(
                        text: 'company_name'.tr,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),

                      const SizedBox(width: 6),
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 16,
                      ),
                      const SizedBox(width: 3),
                      CustomText(
                        text: '4.9',
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // product name
                  CustomText(
                    text: 'Product name',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  // description
                  const CustomText(
                    text: 'Description',
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 4),
                  // price
                  CustomText(
                    text: '1,000 ₽',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildStreamGrid(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('livestreams').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text('No livestreams available'));
      };

      final livestreamsData = snapshot.data!.docs;

      return SizedBox( // Ensure bounded height
        height: 500, // Set an appropriate height
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;
              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 3 : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.80,
                ),
                itemCount: livestreamsData.length,
                itemBuilder: (context, index) {
                  // Cast the document data to a Map
                  final data = livestreamsData[index].data() as Map<String, dynamic>;

                  // Extract fields with a fallback if necessary.
                  final adminName = data['adminName'] as String? ?? 'Unknown';
                  final adminImage = data['adminPhoto'] as String? ?? '';
                  final viewsCount = data['viewsCount'] as int? ?? 0;
                  final title = data['title'] as String? ?? '';

                  return GestureDetector(
                    onTap: () {
                      // Navigate to live stream or any action
                    },
                    child: LiveVideoCard(
                      adminName: adminName,
                      adminImage: adminImage,
                      viewsCount: viewsCount,
                      title: title,
                    ),
                  );
                },
              );
            },
          ),
        ),
      );
    },
  );
}



