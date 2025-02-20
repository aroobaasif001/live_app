import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_gradiant_tab_button.dart';
import 'package:live_app/entities/product_entity.dart';
import 'package:live_app/utils/images_path.dart';
import '../homeMainScreen/liveShoppingScreens/live_shopping_screen.dart';
import '../widgets/live_video_card.dart';
import 'widget/build_action_card.dart';

class FeatureActivityScreen extends StatelessWidget {
  final List<String> categories = ["All", "Streams", "Goods", "Search"];
  RxInt selectedCategoryIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            _buildCategoryTabs(),
            SizedBox(height: 16),
            Obx(() {
              if (categories[selectedCategoryIndex.value] == "Streams") {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("Streams".tr),
                    _buildLiveVideos(context),
                  ],
                );
              } else if (categories[selectedCategoryIndex.value] == "Goods") {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("Goods".tr),
                    _buildProductList(),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("Streams".tr),
                    _buildLiveVideos(context),
                    SizedBox(height: 16),
                    _buildSectionTitle("Goods".tr),
                    _buildProductList(),
                  ],
                );
              }
            }),
            SizedBox(height: 16),
            _buildSectionTitle("Search".tr),
            _buildSearchFilters(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(categories.length, (index) {
            return Obx(() => Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CustomGradiantTabButton(
                    text: categories[index].tr,
                    isSelected: selectedCategoryIndex.value == index,
                    onPressed: () => selectedCategoryIndex.value = index,
                  ),
                ));
          }),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildLiveVideos(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          Get.to(() => LiveShoppingScreen());
        },
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.42,
          ),
          itemCount: 2,
          itemBuilder: (context, index) {
            return LiveVideoCard();
          },
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return SizedBox(
      height: 300,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No products available".tr));
          }
          List<ProductEntity> products = snapshot.data!.docs
              .map((doc) => ProductEntity.fromJson(doc.data() as Map<String, dynamic>))
              .toList();
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return buildAuctionCard(products[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchFilters() {
    return Row(
      children: [
        _buildFilterChip("Electronics".tr, isSelected: false),
        _buildFilterChip("iPhone".tr),
      ],
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[300],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [Text(label), Icon(Icons.close)],
          ),
        ),
      ),
    );
  }
}
