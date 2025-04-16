import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_app/view/market/tabs/product_detail/product_detail_screen.dart';
import '../../../custom_widgets/custom_gradiant_tab_button.dart';
import '../../../entities/product_entity.dart';

class RatesActivitySearchScreen extends StatefulWidget {
  @override
  _RatesActivitySearchScreenState createState() =>
      _RatesActivitySearchScreenState();
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
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
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

    final List<String> images = List<String>.from(data['images'] ?? []);
    final String imageUrl = images.isNotEmpty ? images.first : '';
    final String title = data['title'] ?? 'Unknown';
    final String description = data['description'] ?? '';
    final String ownerId =
        data['id'] ?? ''; // Make sure this field exists in your products
    final dynamic rawPrice = data['price'] ?? 0;
    final String price = rawPrice.toString(); // Convert safely

    final Map<String, dynamic> bidders = data['bidders'] ?? {};
    final double currentUserBid =
        double.tryParse(bidders[currentUserId]?.toString() ?? '0') ?? 0.0;
    final double highestBid = bidders.values.isNotEmpty
        ? bidders.values
            .map((e) => double.tryParse(e.toString()) ?? 0.0)
            .reduce((a, b) => a > b ? a : b)
        : 0.0;

    String statusText = '';
    Color statusColor = Colors.transparent;

    if (selectedCategoryIndex.value == 1 && currentUserBid == highestBid) {
      statusText = 'You are in the lead!';
      statusColor = Colors.blue;
    } else if (selectedCategoryIndex.value == 2 &&
        currentUserBid < highestBid) {
      statusText = 'The bid has been outbid!';
      statusColor = Colors.pink;
    }

    return GestureDetector(
      onTap: () {
        ProductEntity productEntity = ProductEntity(
          id: product.id,
          title: title,
          description: description,
          price: price,
          images: images,
        );
        Get.to(() => ProductDetailScreen(product: productEntity));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 140,
                          height: 140,
                          color: Colors.grey[300],
                        ),
                ),
                // Chat icon with counter
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/Bookmark.png',
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(width: 4),
                        Text("3",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                // Status label
                if (statusText.isNotEmpty)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        statusText,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.storefront,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('UserEntity')
                              .doc(ownerId)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text("Loading...",
                                  style: TextStyle(fontSize: 14));
                            }

                            if (!snapshot.hasData ||
                                !snapshot.data!.exists ||
                                snapshot.data!.data() == null) {
                              return Text("Unknown User",
                                  style: TextStyle(fontSize: 14));
                            }

                            final Map<String, dynamic> userData =
                                snapshot.data!.data() as Map<String, dynamic>;

                            final userName = userData['firstName'] ?? "Unknown";

                            return Text(
                              userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 2),
                            Text("4.9", style: TextStyle(fontSize: 13)),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(description,
                        style: TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Text("$price ₽",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

List<DocumentSnapshot> _getFilteredProducts() {
  if (selectedCategoryIndex.value == 0) return products;

  return products.where((product) {
    final data = product.data() as Map<String, dynamic>?;

    if (data == null || data['bidders'] == null) return false;

    final Map<String, dynamic> bidders = Map<String, dynamic>.from(data['bidders']);

    // Defensive checks
    if (bidders.isEmpty || !bidders.containsKey(currentUserId)) return false;

    final double currentUserBid =
        double.tryParse(bidders[currentUserId].toString()) ?? 0.0;

    final double highestBid = bidders.values
        .map((e) => double.tryParse(e.toString()) ?? 0.0)
        .reduce((a, b) => a > b ? a : b);

    if (selectedCategoryIndex.value == 1) {
      // You are in the lead
      return currentUserBid > 0 && currentUserBid == highestBid;
    } else if (selectedCategoryIndex.value == 2) {
      // The bid has been outbid
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
