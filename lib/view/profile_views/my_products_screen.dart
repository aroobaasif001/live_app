import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/view/profile_views/create_a_product_screen.dart';

import '../../custom_widgets/custom_container.dart';
import '../../custom_widgets/custom_gradient_button.dart';
import '../../custom_widgets/custom_text.dart';
import '../../utils/images_path.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "My Products",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonsTabBar(
                unselectedBackgroundColor: Colors.white,
                // Background for unselected tabs
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
                    // Gradient for selected tab
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                tabs: [
                  Tab(text: "All"),
                  Tab(text: "Active"),
                  Tab(text: "Sold"),
                  Tab(text: "Fix"),
                  Tab(text: "Auction"),
                ],
              ),

              const SizedBox(height: 12),

              // Search Bar
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Product List View
              Expanded(
                child: TabBarView(
                  children: [
                    buildProductList(),
                    buildProductList(),
                    buildProductList(),
                    buildProductList(),
                    buildProductList(),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Floating Action Button
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purpleAccent,
          onPressed: () {
            Get.to(()=>CreateProductScreen());
          },
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildProductList() {
    return ListView(
      children: [
        // Active Products
        buildProductItem(isAuction: false, isArchived: false),
        buildProductItem(isAuction: true, isArchived: false),

        const SizedBox(height: 16),

        // Archive Header
        const CustomText(
          text: "Archive",
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),

        // Archived Products
        buildProductItem(isAuction: false, isArchived: true),
        buildProductItem(isAuction: true, isArchived: true),
      ],
    );
  }

  Widget buildProductItem({required bool isAuction, required bool isArchived}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with Labels & Notification Icon
          Stack(
            children: [
              CustomContainer(
                height: 135,
                width: 135,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: AssetImage(marketImage), fit: BoxFit.cover),
              ),
              Positioned(
                top: 6,
                left: 6,
                child: CustomContainer(
                  height: 20,
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.pinkAccent],
                    // Gradient for selected tab
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  child: CustomText(
                    text: isAuction ? "Auction" : "Fix",
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: CustomContainer(
                  height: 26,
                  width: 40,
                  conColor: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.notifications_none_rounded, size: 14),
                      const SizedBox(width: 2),
                      const CustomText(text: '1', fontSize: 12),
                    ],
                  ),
                ),
              ),
              if (isAuction)
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    borderRadius: BorderRadius.circular(6),
                    conColor: Colors.white,
                    child: CustomText(
                      text: "23 hours left.",
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: "Product name",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                const CustomText(
                  text: "Description",
                  fontSize: 14,
                  color: Colors.grey,
                ),
                CustomText(
                  text: isAuction ? "1,000 ₽ current bid" : "1,000 ₽",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                const SizedBox(height: 16),
                if (!isArchived)
                  CustomContainer(
                    height: 35,
                    width: 100,
                    conColor: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                    child: Center(
                      child: CustomText(
                        text: "Change",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
