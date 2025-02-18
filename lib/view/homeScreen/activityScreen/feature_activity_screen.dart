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
  final List<Map<String, dynamic>> auctions = [
    {
      "image": marketImage,
      "status": "outbid",
      "product": "iPhone 13",
      "description": "Latest iPhone model",
      "price": "1,000 ₽",
      "company": "Apple Store",
      "rating": "4.9"
    },
    {
      "image": marketImage,
      "status": "lead",
      "product": "T-Shirt",
      "description": "Cotton, size M",
      "price": "500 ₽",
      "company": "Clothing Hub",
      "rating": "4.7"
    },
  ];
  final List<Map<String, dynamic>> completedAuctions = [
    {
      "image": marketImage,
      "status": "win",
      "product": "MacBook Air",
      "description": "M2 Chip, 512GB SSD",
      "price": "1,500 ₽",
      "company": "Apple Store",
      "rating": "5.0"
    },
    {
      "image": marketImage,
      "status": "lost",
      "product": "Netflix Premium",
      "description": "1 Year Subscription",
      "price": "900 ₽",
      "company": "Netflix Inc.",
      "rating": "4.8"
    },
  ];

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
            _buildSectionTitle("Streams"),
            _buildLiveVideos(context),
            SizedBox(height: 16),
            _buildSectionTitle("Goods"),
            // ..._getFilteredAuctions()
            //     .map((item) => buildAuctionCard(item))
            //     .toList(),
            SizedBox(
              height: 300,
              child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('products').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
                        }
              
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No products available"));
                        }
              
                        List<ProductEntity> products = snapshot.data!.docs
                .map((doc) => ProductEntity.fromJson(doc.data() as Map<String, dynamic>))
                .toList();
              
                        return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return buildAuctionCard(products[index]); // ✅ Display Products
              },
                        );
                      },
                    ),
            ),
            SizedBox(height: 16),
            _buildSectionTitle("Search"),
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
                    text: categories[index],
                    isSelected: selectedCategoryIndex.value == index,
                    onPressed: () => selectedCategoryIndex.value = index,
                  ),
                ));
          }),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, {bool isSelected = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.purple : Colors.grey[300],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () {},
        child: Text(text,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

          return GestureDetector(
            onTap: () {
              Get.to(() => LiveShoppingScreen());
            },
            child: GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth > 600 ? 3 : 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.42,
              ),
              itemCount: 2,
              itemBuilder: (context, index) {
                return LiveVideoCard();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildGoodsList() {
    return Column(
      children: List.generate(2, (index) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            leading: Image.asset(marketImage, width: 50),
            title: Text("Product name",
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Description\n1,000 ₽"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                Text("4.9"),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSearchFilters() {
    return Row(
      spacing: 8,
      children: [
        _buildFilterChip("Electronics", isSelected: false),
        _buildFilterChip("Iphone"),
      ],
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Colors.grey[300] : Colors.grey[300],
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

  List<Map<String, dynamic>> _getFilteredAuctions() {
    String filter = categories[selectedCategoryIndex.value];
    if (filter == "All") return auctions;
    if (filter == "You are in the lead") {
      return auctions.where((item) => item["status"] == "lead").toList();
    }
    if (filter == "The bid has been outbid") {
      return auctions.where((item) => item["status"] == "outbid").toList();
    }
    return auctions;
  }

  List<Map<String, dynamic>> _getFilteredCompletedAuctions() {
    String filter = categories[selectedCategoryIndex.value];
    if (filter == "All") return completedAuctions;
    return completedAuctions;
  }
}
