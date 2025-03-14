import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_app/view/market/tabs/product_detail/product_detail_screen.dart';
import '../../../custom_widgets/custom_gradiant_tab_button.dart';
import '../../../entities/product_entity.dart';

class RatesActivitySearchScreen extends StatefulWidget {
  @override
  _RatesActivitySearchScreenState createState() => _RatesActivitySearchScreenState();
}

class _RatesActivitySearchScreenState extends State<RatesActivitySearchScreen> {
  RxInt selectedCategoryIndex = 0.obs;
  List<DocumentSnapshot> products = [];
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final List<String> categories = [
    "All".tr,
    "You are in the lead".tr,
    "The bid has been outbid".tr
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('products').get();
    setState(() {
      products = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            _buildCategoryTabs(),
            SizedBox(height: 12),
            Expanded(
              child: Obx(() => SingleChildScrollView(
                child: Column(
                  children: [
                    ..._getFilteredProducts()
                        .map((item) => _buildAuctionCard(item))
                        .toList(),
                    SizedBox(height: 16),
                    Text(
                      "Recently Completed Auctions".tr,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    ..._getRecentlyAuctionedProducts()
                        .map((item) => _buildAuctionCard(item))
                        .toList(),
                  ],
                ),
              )),
            ),
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

  Widget _buildAuctionCard(DocumentSnapshot product) {
    Map<String, dynamic> data = product.data() as Map<String, dynamic>;
    return GestureDetector(
      onTap: (){
        ProductEntity productEntity = ProductEntity(
          id: product.id,
          title: data['title'] ?? "Unknown",
          description: data['description'] ?? "",
          price: data['price'] ?? 0,
          images: List<String>.from(data['images'] ?? []),
        );
        Get.to(()=>ProductDetailScreen(product: productEntity));
      },

      child: Card(
        margin: EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        child: ListTile(
          leading: data['images'] != null && data['images'].isNotEmpty
              ? Image.network(data['images'][0], width: 100, height: 100, fit: BoxFit.cover)
              : Container(width: 100, height: 100, color: Colors.grey),
          title: Text(data['title'] ?? "Unknown"),
          subtitle: Text("${data['description']} - ${data['price']}"),
        ),
      ),
    );
  }

  List<DocumentSnapshot> _getFilteredProducts() {
    if (selectedCategoryIndex.value == 0) return products;

    return products.where((product) {
      Map<String, dynamic> data = product.data() as Map<String, dynamic>;
      if (!data.containsKey('bidders')) return false; // Exclude products without bidders

      Map<String, dynamic> bidders = data['bidders'];
      double currentUserBid = bidders[currentUserId] ?? 0;
      double highestBid = bidders.values.isNotEmpty ? bidders.values.reduce((a, b) => a > b ? a : b) : 0;

      if (selectedCategoryIndex.value == 1) {
        // "You are in the lead" - Check if current user's bid is the highest
        return currentUserBid > 0 && currentUserBid == highestBid;
      } else if (selectedCategoryIndex.value == 2) {
        // "The bid has been outbid" - Check if someone else has a higher bid
        return currentUserBid > 0 && currentUserBid < highestBid;
      }
      return false;
    }).toList();
  }

  List<DocumentSnapshot> _getRecentlyAuctionedProducts() {
    return products.where((product) {
      Map<String, dynamic> data = product.data() as Map<String, dynamic>;
      return data['isSold'] == true;
    }).toList();
  }
}