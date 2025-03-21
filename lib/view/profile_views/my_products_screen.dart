import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/entities/product_entity.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/view/market/tabs/product_detail/product_detail_screen.dart';
import 'package:live_app/view/profile_views/create_a_product_screen.dart';

import '../../custom_widgets/custom_container.dart';
import '../../custom_widgets/custom_gradient_button.dart';
import '../../custom_widgets/custom_text.dart';
import '../../utils/images_path.dart';
import '../../translate/translations_app.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

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
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "my_products".tr,
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
                borderWidth: 0,
                unselectedBorderColor: Colors.transparent,
                borderColor: Colors.transparent,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  Tab(text: "all".tr),
                  Tab(text: "active".tr),
                  Tab(text: "sold".tr),
                  Tab(text: "fix".tr),
                  Tab(text: "auction".tr),
                ],
              ),

              const SizedBox(height: 12),

              // Search Bar
              // Container(
              //   height: 40,
              //   decoration: BoxDecoration(
              //     color: Colors.grey[200],
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   padding: const EdgeInsets.symmetric(horizontal: 12),
              //   child: TextField(
              //     decoration: InputDecoration(
              //       border: InputBorder.none,
              //       hintText: "search".tr,
              //       prefixIcon: Icon(Icons.search, color: Colors.grey),
              //     ),
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "search".tr,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = "";
                              });
                            },
                          )
                        : null,

                  ),
                  textAlignVertical: TextAlignVertical.center, // Vertically center the text

                ),
              ),

              const SizedBox(height: 12),

              // Product List View
              Expanded(
                child: TabBarView(
                  children: [
                    buildProductList("All"),
                    buildProductList("Active"),
                    buildProductList("Sold"),
                    buildProductList("Fix"),
                    buildProductList("Auction"),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed: () => Get.to(() => const CreateProductScreen()),
          child: Container(
            decoration: BoxDecoration(
              gradient: primaryGradientColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: const Icon(Icons.add, size: 28, color: Colors.white),
            ),
          ),
          tooltip: "create_product".tr,
        ),
      ),
    );
  }

  // Widget buildProductList(String filter) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance.collection('products').snapshots(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //         return Center(child: Text("no_products".tr));
  //       }

  //       // Convert each doc into a ProductEntity
  //       List<ProductEntity> products = snapshot.data!.docs
  //           .map((doc) =>
  //               ProductEntity.fromJson(doc.data() as Map<String, dynamic>))
  //           .toList();

  //       // Filter logic
  //       if (filter == "Fix") {
  //         products = products.where((p) => p.saleType == "Buy Now").toList();
  //       } else if (filter == "Auction") {
  //         products = products.where((p) => p.saleType == "Auction").toList();
  //       } else if (filter == "Active") {
  //         products = products
  //             .where((p) => (p.isActive ?? false) && !(p.isSold ?? false))
  //             .toList();
  //       } else if (filter == "Sold") {
  //         products = products.where((p) => p.isSold ?? false).toList();
  //       }

  //       return ListView.builder(
  //         itemCount: products.length,
  //         itemBuilder: (context, index) {
  //           return buildProductItem(products[index]);
  //         },
  //       );
  //     },
  //   );
  // }

  Widget buildProductList(String filter) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("no_products".tr));
        }

        // Convert each doc into a ProductEntity
        List<ProductEntity> products = snapshot.data!.docs
            .map((doc) =>
            ProductEntity.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        // **Filter by current user ID**
        products = products.where((p) => p.id == FirebaseAuth.instance.currentUser!.uid).toList();

        // **Filter logic**
        if (filter == "Fix") {
          products = products.where((p) => p.saleType == "Buy Now").toList();
        } else if (filter == "Auction") {
          products = products.where((p) => p.saleType == "Auction").toList();
        } else if (filter == "Active") {
          products = products
              .where((p) => (p.isActive ?? false) && !(p.isSold ?? false))
              .toList();
        } else if (filter == "Sold") {
          products = products.where((p) => p.isSold ?? false).toList();
        }

        // **Search logic**
        if (_searchQuery.isNotEmpty) {
          products = products
              .where((p) =>
          (p.title?.toLowerCase().contains(_searchQuery) ?? false) ||
              (p.description?.toLowerCase().contains(_searchQuery) ?? false))
              .toList();
        }

        if (products.isEmpty) {
          return Center(child: Text("no_products_found".tr));
        }

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: (){

                  Get.to(() => ProductDetailScreen(product: products[index]));

                },

                child: buildProductItem(products[index]));
          },
        );
      },
    );
  }


  Widget buildProductItem(ProductEntity product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Product image
              CustomContainer(
                height: 135,
                width: 135,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(
                    (product.images != null && product.images!.isNotEmpty)
                        ? product.images!.first
                        : 'https://via.placeholder.com/150',
                  ),
                  fit: BoxFit.cover,
                ),
              ),

              // "Auction" or "Buy Now"
              Positioned(
                top: 6,
                left: 6,
                child: CustomContainer(
                  height: 20,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.pinkAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  child: CustomText(
                    text: product.saleType == "Auction"
                        ? "auction".tr
                        : "buy_now".tr,
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // "SOLD"
              if (product.isSold ?? false)
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: CustomContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    conColor: Colors.red,
                    child: const CustomText(
                      text: "SOLD",
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),

          // Right side info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: product.title ?? "",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                CustomText(
                  text: product.description ?? "",
                  fontSize: 14,
                  color: Colors.grey,
                ),
                CustomText(
                  text: product.saleType == "Auction"
                      ? "${product.startingBid ?? '0'} ₽"
                      : "${product.price ?? '0'} ₽",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                CustomText(
                  text: (product.isActive ?? false) ? "Active" : "Inactive",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color:
                      (product.isActive ?? false) ? Colors.green : Colors.red,
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: CustomText(
                      text: "Change",
                      color: Colors.black,
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
